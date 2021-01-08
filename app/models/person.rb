class Person < ApplicationRecord
  self.implicit_order_column = 'created_at'

  has_many :funding_applications_people, inverse_of: :person
  has_many :funding_applications, through: :funding_applications_people

  attr_accessor :validate_name, :validate_position, :validate_email, :validate_phone_number

  validates :name, presence: true, if: :validate_name?
  validates :position, presence: true, if: :validate_position?
  validates :email, presence: true, 'valid_email2/email': true, if: :validate_email?
  validates :phone_number, presence: true, if: :validate_phone_number?

  def validate_name?
    validate_name == true
  end

  def validate_position?
    validate_position == true
  end

  def validate_email?
    validate_email == true
  end

  def validate_phone_number?
    validate_phone_number == true
  end
end
