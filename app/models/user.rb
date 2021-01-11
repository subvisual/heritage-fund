class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable

  has_many :users_organisations, inverse_of: :user
  has_many :organisations, through: :users_organisations

  has_many :projects

  belongs_to :person, optional: true

  attr_accessor :validate_details, :validate_address

  validates :name, presence: true, if: :validate_details?
  validates :line1, presence: true, if: :validate_address?
  validates :townCity, presence: true, if: :validate_address?
  validates :county, presence: true, if: :validate_address?
  validates :postcode, presence: true, if: :validate_address?
  validates_date :date_of_birth, before: :today, if: :validate_details?

  validate :date_of_birth_is_in_past, if: :validate_details?

  def validate_details?
    validate_details == true
  end

  def validate_address?
    validate_address == true
  end

  def date_of_birth_is_in_past
    return if date_of_birth&.past?

    errors.add(:date_of_birth, 'Date of birth must be in the past')
  end

  def self.current_user(user_id)
    @user = User.find_by(uid: user_id)
  end
end
