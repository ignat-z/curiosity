# frozen_string_literal: true

require 'statements_monitor/subscriber'
require 'rails_helper'

RSpec.describe StatementsMonitor::Subscriber do
  subject { described_class.new }

  let(:checker) { instance_double(StatementsMonitor::CrossDomainStatementsChecker) }

  let(:insert_statement_1) { 'INSERT INTO `adjustment_amounts` (`fund_id`) VALUES (11)' }
  let(:insert_statement_2) { 'INSERT INTO `adjustment_amounts` (`fund_id`) VALUES (12)' }
  let(:update_statement) { "UPDATE `employees` SET `employees`.`forename` = 'John' WHERE `employees`.`id` = 26" }
  let(:delete_statement) { 'DELETE FROM `prefix_letters` WHERE `prefix_letters`.`id` = 2' }
  let(:begin_statement) { 'BEGIN' }

  before do
    allow(StatementsMonitor::CrossDomainStatementsChecker).to receive(:new).and_return(checker)
    allow(Rails.env).to receive(:development?).and_return(true)

    subject.call(nil, nil, nil, nil, sql: insert_statement_1)
    subject.call(nil, nil, nil, nil, sql: insert_statement_2)
    subject.call(nil, nil, nil, nil, sql: begin_statement)
    subject.call(nil, nil, nil, nil, sql: update_statement)
    subject.call(nil, nil, nil, nil, sql: delete_statement)
  end

  describe '#call' do
    it 'stores all the statements' do
      expect(subject.events.map(&:statement).map(&:sql)).to include(insert_statement_1, insert_statement_2, update_statement,
                                                   delete_statement)
    end
  end

  describe '#validate!' do
    let(:callable) { double(call: :result) }

    it 'calls checker' do
      expect(checker).to receive(:call)
      subject.validate! { callable.call }
    end

    it 'clears events after validate' do
      expect(checker).to receive(:call)
      subject.validate! { callable.call }
      expect(subject.events).to be_empty
    end

    it 'clears events after validate even after exception' do
      allow(callable).to receive(:call).and_raise(StandardError)
      expect { subject.validate! { callable.call } }.to raise_error(StandardError)
      expect(subject.events).to be_empty
    end
  end
end
