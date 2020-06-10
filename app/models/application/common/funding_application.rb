class FundingApplication < ApplicationRecord
    has_many :addresses, through: :funding_application_addresses
end
