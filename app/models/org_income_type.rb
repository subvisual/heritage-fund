class OrgIncomeType < ApplicationRecord
  has_many :gp_hef_loans_org_income_types, inverse_of: :org_income_type
  has_many :gp_hef_loans, through: :gp_hef_loans_org_income_types
end
