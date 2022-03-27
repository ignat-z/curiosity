# frozen_string_literal: true

module StatementsMonitor
  class MySqlStatement

    attr_reader :sql

    def initialize(sql)
      @sql = sql
    end

    def supported?
      insert? || delete? || update? || select?
    end

    def transaction_start?
      sql.include?('BEGIN')
    end

    def transaction_finish?
      sql.include?('COMMIT') || sql.include?('ROLLBACK')
    end

    def insert?
      sql.include?('INSERT')
    end

    def delete?
      sql.include?('DELETE')
    end

    def update?
      sql.include?('UPDATE')
    end

    def select?
      sql.start_with?('SELECT')
    end

    def affected_tables
      return [sql.match(/INSERT INTO `(.+?)` /)[1]] if insert?
      return [sql.match(/UPDATE `(.+)` SET/)[1]] if update?
      return [sql.match(/DELETE FROM `(.+?)` /)[1]] if delete?
      return select_tables if select?

      raise 'Unknown statement type'
    end

    private

    def select_tables
      sql.scan(/ FROM `(.+?)`/).flatten + sql.scan(/JOIN `(.+?)`+/).flatten
    end

  end
end