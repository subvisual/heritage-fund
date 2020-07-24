class GpHefLoansRepaymentFreq < ApplicationRecord
    belongs_to :repayment_frequency
    belongs_to :gp_hef_loan
  end
  