class Organisation < ApplicationRecord
  self.implicit_order_column = "created_at"
  has_many :users
  has_many :legal_signatories

  attr_accessor :validate_org_type
  attr_accessor :validate_company_number
  attr_accessor :validate_charity_number
  attr_accessor :validate_address
  attr_accessor :validate_mission

  validates :org_type, presence: true, if: :validate_org_type?
  validates :company_number, numericality: {only_integer: true}, allow_blank: true, if: :validate_company_number?
  validates :charity_number, numericality: {only_integer: true}, allow_blank: true, if: :validate_charity_number?
  validate :validate_mission_array, if: :validate_mission?
  validates :name, presence: true, if: :validate_address?
  validates :line1, presence: true, if: :validate_address?
  validates :townCity, presence: true, if: :validate_address?
  validates :county, presence: true, if: :validate_address?
  validates :postcode, presence: true, if: :validate_address?

  def validate_org_type?
    validate_org_type == true
  end

  def validate_company_number?
    validate_company_number == true
  end

  def validate_charity_number?
    validate_charity_number == true
  end

  def validate_address?
    validate_address == true
  end

  def validate_mission?
    validate_mission == true
  end

  # Custom validator to determine whether any of the items in the incoming mission array
  # are not included in the expected list of options
  def validate_mission_array
    if mission.present?
      mission.each do |m|
        if !["black_or_minority_ethnic_led",
             "disability_led",
             "lgbt_plus_led",
             "female_led",
             "young_people_led"].include? m
          errors.add(:mission, m + " is not a valid selection")
        end
      end
    end
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
      other: 9
  }

end