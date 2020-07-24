class RepaymentFrequency < ApplicationRecord
  has_many :gp_hef_loans_repayment_freqs, inverse_of: :repayment_frequency
  has_many :gp_hef_loans, through: :gp_hef_loans_repayment_freqs
end
