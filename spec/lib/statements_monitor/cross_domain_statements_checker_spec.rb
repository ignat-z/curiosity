# frozen_string_literal: true

require 'statements_monitor/cross_domain_statements_checker'
require 'statements_monitor/my_sql_statement'
require 'rails_helper'

RSpec.describe StatementsMonitor::CrossDomainStatementsChecker do
  Event = Struct.new(:statement, :backtrace)
  
  subject { described_class.new(config) }
      
  let(:statement_1) { instance_double(StatementsMonitor::MySqlStatement, affected_tables: %w[a_table], select?: true, transaction_finish?: false, transaction_start?: false, supported?: true) }
  let(:statement_2) { instance_double(StatementsMonitor::MySqlStatement, affected_tables: %w[b_table], select?: true, transaction_finish?: false, transaction_start?: false, supported?: true) }
  let(:statement_3) { instance_double(StatementsMonitor::MySqlStatement, affected_tables: %w[a_table e_table], select?: true, transaction_finish?: false, transaction_start?: false, supported?: true) }
  let(:statement_4) { instance_double(StatementsMonitor::MySqlStatement, affected_tables: %w[d_a_table d_b_table], select?: true, transaction_finish?: false, transaction_start?: false, supported?: true) }
  let(:statement_5) { instance_double(StatementsMonitor::MySqlStatement, affected_tables: %w[e_table], select?: true, transaction_finish?: false, transaction_start?: false, supported?: true) }
  let(:statement_begin) { instance_double(StatementsMonitor::MySqlStatement, select?: false, transaction_finish?: false, transaction_start?: true) }
  let(:statement_finish) { instance_double(StatementsMonitor::MySqlStatement, select?: false, transaction_finish?: true, transaction_start?: false) }

  describe "when config is on join level" do
    let(:config) { { level: "join", domain_tables: %w[e_table] } }
  
    context "when there is a SELECT statement with a join" do 
      let(:events) do 
        [
          statement_select_many_tables
        ].map { Event.new(_1, []) }
      end
      let(:statement_select_many_tables) { instance_double(StatementsMonitor::MySqlStatement, affected_tables: %w[e_table d_table], select?: true, insert?: false, transaction_finish?: false, transaction_start?: false, supported?: true) }

      it "raises an error" do
        expect { 
          subject.call(events) 
        }.to raise_error("Statements with both monolith and e_table tables are prohibited")      
      end
    end
  end

  describe "when config is on transaction level" do
    let(:config) { { level: "transaction", domain_tables: %w[e_table] } }

    context "when there are statements with both monolith and c_table and d_table tables inside transaction" do
      let(:events) do 
        [
          statement_1, 
          statement_3, 
          statement_begin, 
          statement_2, 
          statement_5, 
          statement_finish
        ].map { Event.new(_1, []) }
      end

      it "raises an error" do
        expect { 
          subject.call(events) 
        }.to raise_error("Statements with both monolith and e_table tables are prohibited")
      end
    end

    context "when there are statements with both monolith and c_table and d_table tables outside of transaction" do
      let(:events) do 
        [
          statement_1, 
          statement_3, 
          statement_begin, 
          statement_finish, 
          statement_2,
          statement_5
        ].map { Event.new(_1, []) }
      end

      it "doesn't raise an error" do
        expect { 
          subject.call(events) 
        }.not_to raise_error
      end
    end
  end

  describe "when config is on statement level" do
    let(:config) { { level: "statement", domain_tables: %w[e_table] } }

    context "when there are statements with both monolith and e_table" do
      let(:events) do 
        [
          statement_1, 
          statement_2, 
          statement_3, 
          statement_4
        ].map { Event.new(_1, []) }
      end
  
      it "raises an error" do
        expect { 
          subject.call(events)
        }.to raise_error(StandardError, "Statements with both monolith and e_table tables are prohibited")
      end

      context "when there are no statements with both monolith and e_table tables" do
        let(:events) do 
          [
            statement_1, 
            statement_2, 
            statement_4
          ].map { Event.new(_1, []) }
        end
    
        it "doesn't raise an error" do
          expect { 
            subject.call(events)
          }.not_to raise_error
        end
      end
    end
  end  
end
