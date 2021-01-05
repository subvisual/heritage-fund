class FundingApplicationsPerson < ApplicationRecord
  belongs_to :funding_application
  belongs_to :person
end
