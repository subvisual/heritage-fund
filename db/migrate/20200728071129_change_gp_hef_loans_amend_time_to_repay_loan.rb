class ChangeGpHefLoansAmendTimeToRepayLoan < ActiveRecord::Migration[6.0]
  def change
    change_column :gp_hef_loans, :time_to_repay_loan, :integer, using: 'time_to_repay_loan::integer'
  end
end
