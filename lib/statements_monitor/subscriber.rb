# frozen_string_literal: true

require 'statements_monitor/cross_domain_statements_checker'
require 'statements_monitor/my_sql_statement'

module StatementsMonitor
  class Subscriber

    attr_reader :events

    def initialize(prefix)
      @checker = StatementsMonitor::CrossDomainStatementsChecker.new(prefix)
      @events = []
    end

    def call(_, _, _, _, values)
      statement = MySqlStatement.new(values[:sql])

      return if active_support_notification_triggered?
      return unless statement.supported?

      @events << statement
    end

    def validate!
      @checker.call(@events.dup)
    ensure
      @events = []
    end

    private

    def active_support_notification_triggered?
      x = caller_locations
      
      x.any? { 
      _1.to_s.include?('/lib/publisher') || _1.to_s.include?('models/arcadia/home.rb:4')
      }
    end

  end
end
