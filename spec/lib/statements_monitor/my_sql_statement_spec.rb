# frozen_string_literal: true

require 'statements_monitor/my_sql_statement'
require 'rails_helper'

RSpec.describe StatementsMonitor::MySqlStatement do
  let(:insert_statement) { 'INSERT INTO `adjustment_amounts` (`adjustment_id`, `fund_id`) VALUES (1, 11)' }
  let(:update_statement) { "UPDATE `employees` SET `employees`.`forename` = 'John' WHERE `employees`.`id` = 26" }
  let(:delete_statement) { 'DELETE FROM `letters` WHERE `letters`.`id` = 2' }

  let(:select_distinct_query) do
    <<~SQL.squish
      SELECT DISTINCT `employment_categories`.`id` FROM `employment_categories`
      LEFT OUTER JOIN `employee_employment_details`
      ON `employee_employment_details`.`employment_category_id` = `employment_categories`.`id`
      WHERE `employee_employment_details`.`employee_id` = 32 LIMIT 1
    SQL
  end
  let(:select_joins_query) do
    <<~SQL.squish
      SELECT 1 AS one FROM `investments` INNER JOIN `transaction_orders`
      ON `transaction_orders`.`id` = `investments`.`transaction_order_id`
      LEFT OUTER JOIN `trade_instructions`
      ON `trade_instructions`.`id` = `investments`.`trade_instruction_id`
      LEFT OUTER JOIN `funds` ON `funds`.`id` = `investments`.`fund_id`
      LEFT OUTER JOIN `employees` ON `employees`.`id` = `investments`.`employee_id`
      WHERE `transaction_orders`.`source_type` = 'BenefitAmount'
      AND `transaction_orders`.`source_id` IN
        (SELECT `benefit_amounts`.`id` FROM `benefit_amounts`
          WHERE `benefit_amounts`.`benefit_id` = 5)
      LIMIT 1
    SQL
  end
  let(:select_joins_alias_query) do
    <<~SQL.squish
      SELECT SUM(`employee_contribution_amounts`.`amount_pennies`) AS sum_employee_pennies,
      SUM(`employer_contribution_amounts`.`amount_pennies`) AS sum_employer_pennies,
      SUM(`other_avc_contribution_amounts`.`amount_pennies`) AS sum_other_avc_pennies,
      SUM(`employee_roth_contribution_amounts`.`amount_pennies`) AS sum_employee_roth_pennies
      FROM `contributions`
      LEFT OUTER JOIN `contribution_amounts` `employee_contribution_amounts`
      ON `employee_contribution_amounts`.`contribution_id` = `contributions`.`id`
      AND `employee_contribution_amounts`.`source_type` = 'employee'
      LEFT OUTER JOIN `contribution_amounts` `employee_roth_contribution_amounts`
      ON `employee_roth_contribution_amounts`.`contribution_id` = `contributions`.`id`
      AND `employee_roth_contribution_amounts`.`source_type` = 'employee_roth'
      LEFT OUTER JOIN `contribution_amounts` `employer_contribution_amounts`
      ON `employer_contribution_amounts`.`contribution_id` = `contributions`.`id`
      AND `employer_contribution_amounts`.`source_type` = 'employer'
      LEFT OUTER JOIN `contribution_amounts` `other_avc_contribution_amounts`
      ON `other_avc_contribution_amounts`.`contribution_id` = `contributions`.`id`
      AND `other_avc_contribution_amounts`.`source_type` = 'other_avc'
      WHERE `contributions`.`cancelled_at` IS NULL
      AND `contributions`.`id` IN
        (SELECT DISTINCT `contributions`.`id` FROM `contributions`
         WHERE `contributions`.`cancelled_at` IS NULL
         AND `contributions`.`employee_id` = 32
         ORDER BY `contributions`.`starts_on` DESC, `contributions`.`employee_id` DESC)
      AND `contributions`.`state` NOT IN ('refunded', 'payment_charged_back')
    SQL
  end

  describe '#select?' do
    context 'with SELECT DISTINCT statement' do
      subject { described_class.new(select_distinct_query) }

      it 'returns true' do
        expect(subject).to be_select
      end
    end

    context 'with SELECT and many JOIN statement' do
      subject { described_class.new(select_joins_query) }

      it 'returns true' do
        expect(subject).to be_select
      end
    end

    context 'with SELECT and many aliased JOIN statement' do
      subject { described_class.new(select_joins_alias_query) }

      it 'returns true' do
        expect(subject).to be_select
      end
    end
  end

  describe '#transaction_start?' do
    context 'with BEGIN statement' do
      subject { described_class.new('BEGIN') }

      it 'returns true' do
        expect(subject).to be_transaction_start
      end
    end
  end

  describe '#transaction_finish?' do
    context 'with COMMIT statement' do
      subject { described_class.new('COMMIT') }

      it 'returns true' do
        expect(subject).to be_transaction_finish
      end
    end

    context 'with ROLLBACK statement' do
      subject { described_class.new('ROLLBACK') }

      it 'returns true' do
        expect(subject).to be_transaction_finish
      end
    end
  end

  describe '#insert?' do
    context 'with INSERT statement' do
      subject { described_class.new(insert_statement) }

      it 'returns true' do
        expect(subject).to be_insert
      end
    end

    context 'with any other statements' do
      it 'returns false' do
        expect(described_class.new(update_statement)).not_to be_insert
        expect(described_class.new(delete_statement)).not_to be_insert
      end
    end
  end

  describe '#delete?' do
    context 'with DELETE statement' do
      subject { described_class.new(delete_statement) }

      it 'returns true' do
        expect(subject).to be_delete
      end
    end

    context 'with any other statements' do
      it 'returns false' do
        expect(described_class.new(update_statement)).not_to be_delete
        expect(described_class.new(insert_statement)).not_to be_delete
      end
    end
  end

  describe '#update?' do
    context 'with UPDATE statement' do
      subject { described_class.new(update_statement) }

      it 'returns true' do
        expect(subject).to be_update
      end
    end

    context 'with any other statements' do
      it 'returns false' do
        expect(described_class.new(insert_statement)).not_to be_update
        expect(described_class.new(delete_statement)).not_to be_update
      end
    end
  end

  describe '#affected_tables' do
    context 'with UPDATE statement' do
      subject { described_class.new(update_statement) }

      it 'returns affected tables' do
        expect(subject.affected_tables).to eql(%w[employees])
      end
    end

    context 'with INSERT statement' do
      subject { described_class.new(insert_statement) }

      it 'returns affected tables' do
        expect(subject.affected_tables).to eql(%w[adjustment_amounts])
      end
    end

    context 'with DELETE statement' do
      subject { described_class.new(delete_statement) }

      it 'returns affected tables' do
        expect(subject.affected_tables).to eql(%w[letters])
      end
    end

    context 'with SELECT DISTINCT statement' do
      subject { described_class.new(select_distinct_query) }

      it 'returns affected tables' do
        expect(subject.affected_tables).to contain_exactly(
          'employment_categories',
          'employee_employment_details'
        )
      end
    end

    context 'with SELECT and many JOIN statement' do
      subject { described_class.new(select_joins_query) }

      it 'returns affected tables' do
        expect(subject.affected_tables).to contain_exactly(
          'investments',
          'transaction_orders',
          'trade_instructions',
          'funds',
          'employees',
          'benefit_amounts'
        )
      end
    end

    context 'with SELECT and many aliased JOIN statement' do
      subject { described_class.new(select_joins_alias_query) }

      it 'returns affected tables' do
        expect(subject.affected_tables).to contain_exactly(
          'contributions',
          'contribution_amounts',
          'contribution_amounts',
          'contribution_amounts',
          'contribution_amounts',
          'contributions'
        )
      end
    end

    context 'when any other statement' do
      subject { described_class.new('BEGIN') }

      it 'raises an error' do
        expect { subject.affected_tables }.to raise_error(StandardError)
      end
    end
  end
end
