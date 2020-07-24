class CreateGpHefLoansRepaymentFreq < ActiveRecord::Migration[6.0]
  def change
    create_table :gp_hef_loans_repayment_freqs, id: :uuid do |t|
      t.references  :gp_hef_loan, type: :uuid, null: false, foreign_key: true 
      t.references  :repayment_frequency, type: :uuid, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
