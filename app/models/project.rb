class Project < ApplicationRecord
    belongs_to :user
    has_one :organisation, through: :user
    has_many :released_forms
    has_many_attached :evidence_of_support_files

    attr_accessor :validate_title
    attr_accessor :validate_start_and_end_dates

    # These attributes are used to set individual error messages
    # for each of the project date input fields
    attr_accessor :start_date_day
    attr_accessor :start_date_month
    attr_accessor :start_date_year
    attr_accessor :end_date_day
    attr_accessor :end_date_month
    attr_accessor :end_date_year

    validates :project_title, presence: true, length: { maximum: 255 }, if: :validate_title?
    validates :start_date_day, presence: true, if: :validate_start_and_end_dates?
    validates :start_date_month, presence: true, if: :validate_start_and_end_dates?
    validates :start_date_year, presence: true, if: :validate_start_and_end_dates?
    validates :end_date_day, presence: true, if: :validate_start_and_end_dates?
    validates :end_date_month, presence: true, if: :validate_start_and_end_dates?
    validates :end_date_year, presence: true, if: :validate_start_and_end_dates?

    validate :start_date_is_valid_date, if: :validate_start_and_end_dates?
    validate :end_date_is_valid_date, if: :validate_start_and_end_dates?
    validate :start_date_is_before_end_date, if: :validate_start_and_end_dates?

    def validate_title?
        validate_title == true
    end

    def validate_start_and_end_dates?
        validate_start_and_end_dates == true
    end

    # This validation methods initially confirms that the date entered is valid,
    # before then confirming that it does not occur in the past
    def start_date_is_valid_date
        if !Date.valid_date? start_date_year.to_i, start_date_month.to_i, start_date_day.to_i
            self.errors.add(:start_date, "Enter a valid project start date")
        else
            unless Date.new(start_date_year.to_i, start_date_month.to_i, start_date_day.to_i) > Date.today
                self.errors.add(:start_date, "Start date cannot be in past")
            end
        end
    end

    # This validation methods initially confirms that the date entered is valid,
    # before then confirming that it does not occur in the past
    def end_date_is_valid_date
        if !Date.valid_date? end_date_year.to_i, end_date_month.to_i, end_date_day.to_i
            self.errors.add(:end_date, "Enter a valid project end date")
        else
            unless Date.new(end_date_year.to_i, end_date_month.to_i, end_date_day.to_i) > Date.today
                self.errors.add(:end_date, "End date cannot be in past")
            end
        end
    end

    # This validation method will only run if no start or end date errors
    # are already present within the model errors hash
    def start_date_is_before_end_date
        unless self.errors.key?(:start_date) or self.errors.key?(:end_date)
            unless Date.new(end_date_year.to_i, end_date_month.to_i, end_date_day.to_i) >
                Date.new(start_date_year.to_i, start_date_month.to_i, start_date_day.to_i)
                self.errors.add(:start_date, "Start date cannot be after end date")
                self.errors.add(:end_date, "End date cannot be before start date")
            end
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
