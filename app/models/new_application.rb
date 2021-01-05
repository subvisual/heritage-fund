class NewApplication
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :application_type

  attr_accessor :validate_application_type_presence

  validates :application_type, presence: true, if: :validate_application_type_presence?

  def validate_application_type_presence?
    validate_application_type_presence == true
  end

  def update(attributes)
    self.attributes = attributes
  end
end
