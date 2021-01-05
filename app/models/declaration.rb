class Declaration < ApplicationRecord
  self.implicit_order_column = "created_at"

  has_many :funding_applications_dclrtns, inverse_of: :declaration
  has_many :funding_applications, through: :funding_applications_dclrtns

  attr_accessor :applicants_response

  validates :declaration_type, presence: true
  validates :json, presence: true
  validates :version, presence: true
  validates :grant_programme, presence: true
end
