# frozen_string_literal: true

require 'statements_monitor/cross_domain_statements_checker'
require 'statements_monitor/my_sql_statement'

module StatementsMonitor
  class Subscriber
    StatementEvent = Struct.new(:statement, :backtrace)

    attr_reader :events

    def initialize
      @checker = StatementsMonitor::CrossDomainStatementsChecker.new
      @events = []
    end

    def call(_, _, _, _, values)
      @events << StatementEvent.new(MySqlStatement.new(values[:sql]), caller)
    end

    def validate!
      return yield unless Rails.env.development?
      
      subscriber = ActiveSupport::Notifications.subscribe('sql.active_record', self)
      yield.tap { @checker.call(@events.dup) }
    ensure
      @events = []
      ActiveSupport::Notifications.unsubscribe(subscriber)
    end
  end
end
