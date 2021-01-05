class CreateGpHefLoansOrgIncomeTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_hef_loans_org_income_types, id: :uuid do |t|
      t.references :gp_hef_loan, type: :uuid, null: false, foreign_key: true
      t.references :org_income_type, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
