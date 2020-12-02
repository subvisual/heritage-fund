class RemoveAllLoansTables < ActiveRecord::Migration[6.0]

  def up
    drop_table :gp_hef_loans_org_income_types
    drop_table :gp_hef_loans_repayment_freqs
    drop_table :repayment_frequencies
    drop_table :gp_hef_loans_plans_for_loans
    drop_table :plans_for_loans
    drop_table :gp_hef_loans
  end

  # Use of empty create_table blocks is used to ensure that migration is reversible
  def down
    create_table :gp_hef_loans
    create_table :plans_for_loans
    create_table :gp_hef_loans_plans_for_loans
    create_table :repayment_frequencies
    create_table :gp_hef_loans_repayment_freqs
    create_table :gp_hef_loans_org_income_types
  end

end
