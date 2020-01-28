class IsNotSameAsMainContactValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value == User.find_by(organisation_id: record.organisation).email
      record.errors[attribute] << (options[:message] || "must be different to your email address")
    end
  end
end

class LegalSignatory < ApplicationRecord
  belongs_to :organisation
  self.implicit_order_column = "created_at"

  attr_accessor :validate_name
  attr_accessor :validate_email_address
  attr_accessor :validate_phone_number

  validates :name, presence: true, if: :validate_name?
  validates :email_address, presence: true, is_not_same_as_main_contact: true, if: :validate_email_address?
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
