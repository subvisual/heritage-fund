class GpHefLoansPlansForLoan < ApplicationRecord
  belongs_to :plans_for_loan
  belongs_to :gp_hef_loan
end
