class GpHefLoansOrgIncomeType < ApplicationRecord
    belongs_to :org_income_type
    belongs_to :gp_hef_loan
  end
  