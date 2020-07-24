class CreateGpHefLoans < ActiveRecord::Migration[6.0]
    def change
      create_table :gp_hef_loans, id: :uuid do |t|
        t.text :previous_project_reference
        t.boolean :can_legally_take_on_debt
        t.boolean :any_debt_restrictions
        t.text    :debt_description
        t.boolean :can_provide_security
        t.boolean :security_restrictions
        t.text    :security_description
        t.boolean :has_had_an_average_yearly_cash_surplus
        t.integer :average_yearly_cash_surplus
        t.boolean :has_had_a_surplus_in_last_reporting_year
        t.integer :cash_surplus_in_last_year
        t.boolean :bankruptcy_or_administration
        t.text    :bankruptcy_or_administration_description
        t.boolean :considers_state_aid
        t.boolean :has_applied_for_grant_or_loan
        t.text    :other_funding_details
        t.text    :efforts_to_reduce_borrowing
        t.text    :plans_for_loan_description
        t.text    :time_to_repay_loan
        t.text    :cashflow_understanding
        t.integer :loan_amount_requested
        t.text    :custom_org_income_type
              
        t.references :funding_application, type: :uuid, null: false, foreign_key: true

        t.timestamps
      end
    end
  end
