# frozen_string_literal: true

module StatementsMonitor
  class CrossDomainStatementsChecker
    def initialize(config = YAML.load_file("#{Rails.root}/config/statements_monitor.yml", symbolize_names: true))
      @config = config
    end

    def call(events)
      events.reject! { active_support_notification_triggered?(_1.backtrace) }
      events.reject! { ignore_list_triggered?(_1.backtrace) }

      valid = case @config.fetch(:level) 
      in "transaction"
        transaction_level_valid?(events)
      in "statement"
        statement_level_valid?(events)
      in "join"
        join_level_tables?(events)
      else 
        raise "Unknown isolation level: #{@config.level}"
      end

      raise "Statements with both monolith and #{@config[:domain_tables].join(", ")} tables are prohibited" unless valid
    end

    private

    def transaction_level_valid?(events)
      tranasctions = []
      current_transaction = []
      in_porgress = false
      
      events.each do |event|
        if event.statement.transaction_finish?
          tranasctions << current_transaction
          in_porgress = false
          current_transaction = []
        elsif event.statement.transaction_start?
          in_porgress = true
        else 
          current_transaction << event if in_porgress && event.statement.supported?
        end
      end

      tranasctions
        .map { |transaction| transaction.map(&:statement).flat_map(&:affected_tables).uniq }
        .none? { prohibited?(_1) }
    end
    
    def statement_level_valid?(events)
      tables = events
        .select { _1.statement.supported? }
        .map(&:statement).flat_map(&:affected_tables).uniq
      
      !prohibited?(tables)
    end

    def join_level_tables?(events)
      events
        .select { _1.statement.select? }
        .map(&:statement)
        .map(&:affected_tables)
        .none? { prohibited?(_1) }
    end

    def prohibited?(tables)
      tables.any? { |name| @config[:domain_tables].include?(name) } &&
        tables.any? { |name| !@config[:domain_tables].include?(name) }
    end

    def active_support_notification_triggered?(backtrace)
      backtrace.any? { _1.to_s.include?('/lib/publisher') }
    end

    def ignore_list_triggered?(backtrace)
      backtrace.any? { |line| @config[:ignored_calls].to_a.any? { |ignored| line.include?(ignored) } }
    end
  end
end