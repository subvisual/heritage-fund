class Project < ApplicationRecord
    include ActiveModel::Validations

    belongs_to :user
    has_one :organisation, through: :user
    has_many :released_forms
    has_many :cash_contributions
    has_many :project_costs
    has_many_attached :evidence_of_support_files
    accepts_nested_attributes_for :cash_contributions, :project_costs

    attr_accessor :validate_title
    attr_accessor :validate_start_and_end_dates
    attr_accessor :validate_same_location
    attr_accessor :validate_address
    attr_accessor :validate_description
    attr_accessor :validate_difference
    attr_accessor :validate_matter
    attr_accessor :validate_heritage_description
    attr_accessor :validate_best_placed_description
    attr_accessor :validate_involvement_description

    # These attributes are used to set individual error messages
    # for each of the project date input fields
    attr_accessor :start_date_day
    attr_accessor :start_date_month
    attr_accessor :start_date_year
    attr_accessor :end_date_day
    attr_accessor :end_date_month
    attr_accessor :end_date_year

    attr_accessor :same_location

    validates :project_title, presence: true, length: { maximum: 255 }, if: :validate_title?
    validates :start_date_day, presence: true, if: :validate_start_and_end_dates?
    validates :start_date_month, presence: true, if: :validate_start_and_end_dates?
    validates :start_date_year, presence: true, if: :validate_start_and_end_dates?
    validates :end_date_day, presence: true, if: :validate_start_and_end_dates?
    validates :end_date_month, presence: true, if: :validate_start_and_end_dates?
    validates :end_date_year, presence: true, if: :validate_start_and_end_dates?

    validates_with ProjectValidator, if: :validate_no_errors && :validate_start_and_end_dates?

    validates :project_title, presence: true, length: { maximum: 255 }, if: :validate_title?
    validates :same_location, presence: true, if: :validate_same_location?
    validates :line1, presence: true, if: :validate_address?
    validates :townCity, presence: true, if: :validate_address?
    validates :county, presence: true, if: :validate_address?
    validates :postcode, presence: true, if: :validate_address?
    validates :same_location, presence: true, if: :validate_same_location?
    validates :description, presence: true, if: :validate_description?
    validates :involvement_description, presence: true, if: :validate_involvement_description?

    validate do
        validate_length(
            :description,
            500,
            "Project description must be 500 words or fewer"
        ) if validate_description?
    end

    validate do
        validate_length(
            :difference,
            500,
            "Description of the difference your project will make must be 500 words or fewer"
        ) if validate_difference?
    end

    validate do
        validate_length(
            :matter,
            500,
            "Description of why your project matters to you and your community must be 500 words or fewer"
        ) if validate_matter?
    end

    validate do
        validate_length(
            :heritage_description,
            500,
            "Description of your project heritage must be 500 words or fewer"
        ) if validate_heritage_description?
    end

    validate do
        validate_length(
            :best_placed_description,
            500,
            "Description of why your organisation is best placed to deliver your project must be 500 words or fewer"
        ) if validate_best_placed_description?
    end

    validate do
        validate_length(
            :involvement_description,
            300,
            "Description of how your project will involve a wider range of people must be 300 words or fewer"
        ) if validate_involvement_description?
    end

    def validate_title?
        validate_title == true
    end

    def validate_start_and_end_dates?
        validate_start_and_end_dates == true
    end

    def validate_no_errors?
        self.errors.empty?
    end

    def validate_same_location?
        validate_same_location == true
    end

    def validate_address?
        validate_address == true
    end

    def validate_description?
        validate_description == true
    end

    def validate_difference?
        validate_difference == true
    end

    def validate_matter?
        validate_matter == true
    end

    def validate_heritage_description?
        validate_heritage_description == true
    end

    def validate_best_placed_description?
        validate_best_placed_description == true
    end

    def validate_involvement_description?
        validate_involvement_description == true
    end

    def validate_length(field, max_length, error_msg)

        word_count = self.public_send(field).split(' ').count

        logger.debug "#{field} word count is #{word_count}"

        if word_count > max_length
            self.errors.add(field, error_msg)
        end

    end

    def to_salesforce_json
        Jbuilder.encode do |json|
            json.ignore_nil!
            json.meta do
                json.set!('applicationId', self.id)
                json.set!('form', "3-10k-grant")
                json.set!('schemaVersion', "v1.x")
                json.set!('startedAt', self.created_at)
                json.set!('username', self.user.email)
            end
            json.application do
                json.set!('organisationName', self.organisation.name)
                json.set!('organisationMission',
                          self.organisation.mission.map!(&:dasherize).map { |m| m == 'lgbt-plus-led' ? 'lgbt+-led' : m })
                json.set!('organisationType', self.organisation.org_type.dasherize)
                json.set!('companyNumber', self.organisation.company_number&.to_s)
                json.set!('charityNumber', self.organisation.charity_number&.to_s)
                json.organisationAddress do
                    json.line1 self.organisation.line1
                    json.line2 self.organisation.line2
                    json.line3 self.organisation.line3
                    json.county self.organisation.county
                    json.townCity self.organisation.townCity
                    json.postcode self.organisation.postcode
                end
                set_legal_signatory_fields = ->(ls) {
                    json.set!("name", ls.name)
                    json.set!("email", ls.email_address)
                    json.set!("phone", ls.phone_number)
                }
                @ls_one = self.organisation.legal_signatories.first
                json.authorisedSignatoryOneDetails do
                    set_legal_signatory_fields.call(@ls_one)
                end
                @ls_two = self.organisation.legal_signatories.second
                if @ls_two.present?
                    json.authorisedSignatoryTwoDetails do
                        set_legal_signatory_fields.call(@ls_two)
                    end
                end
            end
        end
    end
end
