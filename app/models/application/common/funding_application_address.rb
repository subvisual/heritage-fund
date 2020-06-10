class FundingApplicationAddress < ApplicationRecord
  has_one :address
  has_one :funding_application
end
