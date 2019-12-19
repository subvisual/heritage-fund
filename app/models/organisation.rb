class Organisation < ApplicationRecord
  has_many :users
  has_many :legal_signatories
  attr_accessor :validate_org_type
  attr_accessor :validate_company_number
  attr_accessor :validate_charity_number

  validates :org_type, presence: true, if: :validate_org_type?
  validates :company_number, numericality: {only_integer: true}, allow_blank: true, if: :validate_company_number?
  validates :charity_number, numericality: {only_integer: true}, allow_blank: true, if: :validate_charity_number?

  def validate_company_number?
    validate_company_number == true
  end

  def validate_charity_number?
    validate_charity_number == true
  end

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