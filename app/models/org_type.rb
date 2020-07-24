class OrgType < ApplicationRecord
  has_many :organisations_org_types, inverse_of: :org_type
  has_many :organisations, through: :organisations_org_types
end
