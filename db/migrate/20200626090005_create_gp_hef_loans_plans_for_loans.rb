class CreateGpHefLoansPlansForLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_hef_loans_plans_for_loans, id: :uuid do |t|
      t.references  :gp_hef_loan, type: :uuid, null: false, foreign_key: true 
      t.references  :plans_for_loan, type: :uuid, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
