class PreApplication < ApplicationRecord

  belongs_to :organisation, optional: true
  belongs_to :heard_about_type, optional: true

  has_many :pre_applications_people, inverse_of: :pre_application
  has_many :people, through: :pre_applications_people
  has_many :relationship_types, through: :pre_applications_people

  has_many :pre_applications_dclrtns, inverse_of: :pre_application
  has_many :declarations, through: :pre_applications_dclrtns

  has_one :pa_project_enquiry
  has_one :pa_expression_of_interest

  accepts_nested_attributes_for :organisation, :people, :declarations

  # attr_accessor :validate_people
  # attr_accessor :validate_declarations

  # validates_associated :organisation
  # validates_associated :people if :validate_people
  # validates_associated :declarations, if: :validate_declarations?
end

