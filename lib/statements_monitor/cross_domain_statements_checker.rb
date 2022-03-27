# frozen_string_literal: true

module StatementsMonitor
  class CrossDomainStatementsChecker

    def initialize(prefix)
      @prefix = prefix
    end

    def call(events)
      tables = events.flat_map(&:affected_tables).uniq

      raise "Statements with both monolith and `#{@prefix}` tables are prohibited" if prohibited?(tables)
    end

    private

    def prohibited?(tables)
      tables.any? { |name| name.start_with?(@prefix) } &&
        tables.any? { |name| !name.start_with?(@prefix) }
    end

  end
end