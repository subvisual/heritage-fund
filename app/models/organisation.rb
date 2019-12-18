class Organisation < ApplicationRecord
  has_many :users
  has_many :legal_signatories
  attr_accessor :validate_org_type

  validates :org_type, presence: true, if: :validate_org_type

  def validate_org_type?
    validate_org_type == true
  end

  enum org_type: {
      registered_charity: 0,
      local_authority: 1,
      registered_company: 2,
      community_interest_company: 3,
      faith_based_organisation: 4,
      church_organisation: 5,
      community_group: 6,
      voluntary_group: 7,
      individual_private_owner_of_heritage: 8,
      other: 9}

end