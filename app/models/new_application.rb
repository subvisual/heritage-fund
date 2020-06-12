class NewApplication

    include ActiveModel::Model
    include ActiveModel::Attributes

    attr_accessor :application_type

    attr_accessor :validate_application_type

    validates :application_type, presence: true, if: :validate_application_type?

    def validate_application_type?
        validate_application_type == true
    end

    def update(attributes)
        self.attributes = attributes
    end

end
