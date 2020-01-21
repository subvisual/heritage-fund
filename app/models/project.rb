class Project < ApplicationRecord
    include ActiveModel::Validations

    belongs_to :user
    has_one :organisation, through: :user
    has_many :released_forms
    has_many :cash_contributions
    has_many :non_cash_contributions
    has_many :project_costs
    has_many :volunteers
    has_many_attached :evidence_of_support_files
    has_one_attached :capital_work_file
    accepts_nested_attributes_for :cash_contributions, :non_cash_contributions, :project_costs, :volunteers

    validates_associated :cash_contributions, if: :validate_cash_contributions?
    validates_associated :non_cash_contributions, if: :validate_non_cash_contributions?
    validates_associated :project_costs, if: :validate_project_costs?
    validates_associated :volunteers, if: :validate_volunteers?

    attr_accessor :validate_title
    attr_accessor :validate_start_and_end_dates
    attr_accessor :validate_same_location
    attr_accessor :validate_address
    attr_accessor :validate_capital_work
    attr_accessor :validate_capital_work_file
    attr_accessor :validate_permission_type
    attr_accessor :validate_permission_description_yes
    attr_accessor :validate_permission_description_x_not_sure
    attr_accessor :validate_description
    attr_accessor :validate_difference
    attr_accessor :validate_matter
    attr_accessor :validate_heritage_description
    attr_accessor :validate_best_placed_description
    attr_accessor :validate_involvement_description
    attr_accessor :validate_other_outcomes
    attr_accessor :validate_project_costs
    attr_accessor :validate_cash_contributions
    attr_accessor :validate_non_cash_contributions
    attr_accessor :validate_volunteers
    attr_accessor :validate_cash_contributions_question
    attr_accessor :validate_non_cash_contributions_question
    attr_accessor :validate_confirm_declaration

    # These attributes are used to set individual error messages
    # for each of the project date input fields
    attr_accessor :start_date_day
    attr_accessor :start_date_month
    attr_accessor :start_date_year
    attr_accessor :end_date_day
    attr_accessor :end_date_month
    attr_accessor :end_date_year

    attr_accessor :cash_contributions_question
    attr_accessor :non_cash_contributions_question

    attr_accessor :same_location

    attr_accessor :permission_description_yes
    attr_accessor :permission_description_x_not_sure

    attr_accessor :confirm_declaration

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
    validates_inclusion_of :capital_work, in: [true, false], if: :validate_capital_work?
    validates :permission_type, presence: true, if: :validate_permission_type?
    validates :permission_description_yes, presence: true, if: :validate_permission_description_yes?
    validates :permission_description_x_not_sure, presence: true, if: :validate_permission_description_x_not_sure?
    validates :description, presence: true, if: :validate_description?
    validates :involvement_description, presence: true, if: :validate_involvement_description?
    validates_inclusion_of :cash_contributions_question,
                           in: ["true", "false"],
                           if: :validate_cash_contributions_question?
    validates_inclusion_of :non_cash_contributions_question,
                           in: ["true", "false"],
                           if: :validate_non_cash_contributions_question?
    validates :confirm_declaration, presence: true, if: :validate_confirm_declaration?

    validate do
        validate_file_attached(
            :capital_work_file,
            "Condition survey must be attached if capital work is part of your project"
        ) if validate_capital_work_file?
    end

    validate do
        validate_length(
            :description,
            500,
            "Project description must be 500 words or fewer"
        ) if validate_description?
    end

    validate do
        validate_length(
            :permission_description_yes,
            300,
            "Description must be 300 words or fewer"
        ) if validate_permission_description_yes?
    end

    validate do
        validate_length(
            :permission_description_x_not_sure,
            300,
            "Description must be 300 words or fewer"
        ) if validate_permission_description_x_not_sure?
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

    validate do
        for i in 2..9 do
            validate_length(
                "outcome_#{i}_description",
                300,
                "Description of how you will meet this outcome must be 300 words or fewer"
            ) if validate_other_outcomes?
        end
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

    def validate_capital_work?
        validate_capital_work == true
    end

    def validate_capital_work_file?
        validate_capital_work_file == true
    end

    def validate_permission_type?
        validate_permission_type == true
    end

    def validate_permission_description_yes?
        validate_permission_description_yes == true
    end

    def validate_permission_description_x_not_sure?
        validate_permission_description_x_not_sure == true
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

    def validate_other_outcomes?
        validate_other_outcomes == true
    end

    def validate_project_costs?
        validate_project_costs == true
    end

    def validate_cash_contributions_question?
        validate_cash_contributions_question == true
    end

    def validate_cash_contributions?
        validate_cash_contributions == true
    end

    def validate_non_cash_contributions_question?
        validate_non_cash_contributions_question == true
    end

    def validate_non_cash_contributions?
        validate_non_cash_contributions == true
    end

    def validate_volunteers?
        validate_volunteers == true
    end

    def validate_confirm_declaration?
        validate_confirm_declaration == true
    end

    enum permission_type: {
        yes: 0,
        no: 1,
        x_not_sure: 2
    }

    def validate_file_attached(field, error_msg)
        unless self.public_send(field).attached?
            errors.add(field, error_msg)
        end
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
                json.set!('projectName', self.project_title)
                json.projectDateRange do
                    json.startDate self.start_date
                    json.endDate self.end_date
                end
                json.projectAddress do
                    json.line1 self.line1
                    json.line2 self.line2
                    json.line3 self.line3
                    json.county self.county
                    json.townCity self.townCity
                    json.projectPostcode self.postcode
                end
                json.set!('yourIdeaProject', self.description)
                json.set!('projectDifference', self.difference)
                json.set!('projectCommunity', self.matter)
                json.set!('projectOrgBestPlace', self.best_placed_description)
                json.set!('projectAvailable', self.heritage_description)
                json.set!('projectOutcome1', self.involvement_description)
                json.set!('projectOutcome2', self.outcome_2_description)
                json.set!('projectOutcome3', self.outcome_3_description)
                json.set!('projectOutcome4', self.outcome_4_description)
                json.set!('projectOutcome5', self.outcome_5_description)
                json.set!('projectOutcome6', self.outcome_6_description)
                json.set!('projectOutcome7', self.outcome_7_description)
                json.set!('projectOutcome8', self.outcome_8_description)
                json.set!('projectOutcome9', self.outcome_9_description)
                json.set!('projectOutcome2Checked', self.outcome_2)
                json.set!('projectOutcome3Checked', self.outcome_3)
                json.set!('projectOutcome4Checked', self.outcome_4)
                json.set!('projectOutcome5Checked', self.outcome_5)
                json.set!('projectOutcome6Checked', self.outcome_6)
                json.set!('projectOutcome7Checked', self.outcome_7)
                json.set!('projectOutcome8Checked', self.outcome_8)
                json.set!('projectOutcome9Checked', self.outcome_9)
                json.projectCosts do
                    json.child! {
                        json.costId 'baa49446-cb70-46c7-ade1-0e17ad450c8a'
                        json.costType 'new-staff'
                        json.costDescription 'Dummy data'
                        json.costAmount '1000'
                    }
                end
                json.projectVolunteers do
                    json.child! {
                        json.description 'Dummy data'
                        json.hours 10
                    }
                end
                json.nonCashContributions do
                    json.child! {
                        json.description 'Dummy data'
                        json.estimatedValue 1000
                        json.secured 'not-sure'
                    }
                end
                json.cashContributions do
                    json.child! {
                        json.description 'Dummy data'
                        json.amount 2000
                        json.secured 'no'
                        json.id 'c4237718-ced7-4d03-a95b-1eceaecfdbe0'
                    }
                end
                json.set!('organisationId', self.organisation.id)
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
