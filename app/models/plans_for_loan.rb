class PlansForLoan < ApplicationRecord
  has_many :gp_hef_loans_plans_for_loans, inverse_of: :plans_for_loan
  has_many :gp_hef_loans, through: :gp_hef_loans_plans_for_loans
end
