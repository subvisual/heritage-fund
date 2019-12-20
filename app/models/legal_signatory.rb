class LegalSignatory < ApplicationRecord

  attr_accessor :validate_name
  attr_accessor :validate_email_address
  attr_accessor :validate_phone_number

  validates :name, presence: true, if: :validate_name?
  validates :email_address, presence: true, if: :validate_email_address?
  validates :phone_number, presence: true, if: :validate_phone_number?

  def validate_name?
    validate_name == true
  end

  def validate_email_address?
    validate_email_address == true
  end

  def validate_phone_number?
    validate_phone_number == true
  end

end
