class FundingApplication < ApplicationRecord

  has_many :addresses, through: :funding_application_addresses

  has_one :gp_hef_loan
  belongs_to :organisation, optional: true

  has_many :funding_applications_people, inverse_of: :funding_application
  has_many :people, through: :funding_applications_people

  has_many :funding_applications_dclrtns, inverse_of: :funding_application
  has_many :declarations, through: :funding_applications_dclrtns

  accepts_nested_attributes_for :gp_hef_loan, :organisation, :people, :declarations

  attr_accessor :validate_people
  attr_accessor :validate_declarations

  validates_associated :organisation, :gp_hef_loan
  validates_associated :people if :validate_people
  validates_associated :declarations, if: :validate_declarations

  def validate_people?
      validate_people == true
  end

  def validate_declarations?
      validate_declarations == true
  end

  # Method used to construct a JSON representation of the FundingApplication
  # which can then be sent through to Microsoft SharePoint via the 
  # SharePoint REST API
  def gp_hef_loan_to_sharepoint_json

    get_declarations(self.declarations)

    Jbuilder.encode do |json|

      json.ignore_nil!

      json.__metadata do
        json.set!(
          'type',
          Rails.configuration.x.sharepoint.list_item_entity_type
        )
      end

      # Funding application specific details
      json.set!('Title', self.id)
      json.set!('Submission_x0020_Date', self.submitted_on)

      # Organisation specific details
      json.set!('Organisation_x0020_Name', self.organisation.name)
      if self.organisation.org_types.present?
        json.set!(
          'Organisation_x0020_Type',
          active_record_collection_to_array(
            self.organisation.org_types,
            'name'
          )
        )
      end
      json.set!(
        'Other_x0020_Organisation_x0020_T',
        self.organisation.custom_org_type
      )

      # Contact details for first associated Person
      json.set!(
        'Contact_x0020_Name_x0020__x002d_',
        self.people.order(:created_at).first.name
      )
      json.set!(
        'Contact_x0020_1_x0020__x002d__x01',
        self.people.order(:created_at).first.position
      )
      json.set!(
        'Contact_x0020_1_x0020__x002d__x0',
        self.people.order(:created_at).first.email
      )
      json.set!(
        'Contact_x0020_1_x0020__x002d__x00',
        self.people.order(:created_at).first.phone_number
      )

      # Contact details for second associated Person
      json.set!(
        'Contact_x0020_2_x0020__x002d__x0',
        self.people.order(:created_at).second.name
      )
      json.set!(
        'Contact_x0020_2_x0020__x002d__x02',
        self.people.order(:created_at).second.position
      )
      json.set!(
        'Contact_x0020_2_x0020__x002d__x00',
        self.people.order(:created_at).second.email
      )
      json.set!(
        'Contact_x0020_2_x0020__x002d__x01',
        self.people.order(:created_at).second.phone_number
      )

      # Loan application specific details
      json.set!(
        'Project_x0020_Reference_x0020_ID',
        self.gp_hef_loan.previous_project_reference
      )
      json.set!(
        'Can_x0020_Legally_x0020_Take_x00',
        self.gp_hef_loan.can_legally_take_on_debt ? "Yes" : "No"
      )
      json.set!(
        'Any_x0020_Debt_x0020_Restriction',
        self.gp_hef_loan.any_debt_restrictions ? "Yes" : "No"
      )
      json.set!(
        'Description_x0020_of_x0020_Debt_',
        self.gp_hef_loan.debt_description
      )
      json.set!(
        'Can_x0020_Provide_x0020_Security',
        self.gp_hef_loan.can_provide_security ? "Yes" : "No"
      )
      json.set!(
        'Security_x0020_Restrictions',
        self.gp_hef_loan.security_restrictions ? "Yes" : "No"
      )
      json.set!(
        'Description_x0020_of_x0020_Secur',
        self.gp_hef_loan.security_description
      )
      json.set!(
        'Has_x0020_had_x0020_an_x0020_Ave',
        self.gp_hef_loan.has_had_an_average_yearly_cash_surplus ? "Yes" : "No"
      )
      json.set!(
        'Average_x0020_Yearly_x0020_Cash_',
        self.gp_hef_loan.average_yearly_cash_surplus
      )
      json.set!(
        'Surplus_x0020_in_x0020_Last_x002',
        self.gp_hef_loan.has_had_a_surplus_in_last_reporting_year ? "Yes" : "No"
      )
      json.set!(
        'Cash_x0020_Surplus_x0020_in_x002',
        self.gp_hef_loan.cash_surplus_in_last_year
      )
      json.set!(
        'Organisation_x0020_Bankruptcy_x0',
        self.gp_hef_loan.bankruptcy_or_administration ? "Yes" : "No"
      )
      json.set!(
        'Organisation_x0020_Bankruptcy_x00',
        self.gp_hef_loan.bankruptcy_or_administration_description
      )
      json.set!(
        'Application_x0020_Considers_x002',
        self.gp_hef_loan.considers_state_aid ? "Yes" : "No"
      )
      json.set!(
        'Already_x0020_Applied_x0020_for_',
        self.gp_hef_loan.has_applied_for_grant_or_loan ? "Yes" : "No"
      )
      json.set!(
        'Other_x0020_Funding_x0020_Detail',
        self.gp_hef_loan.other_funding_details
      )
      json.set!(
        'Efforts_x0020_to_x0020_Reduce_x0',
        self.gp_hef_loan.efforts_to_reduce_borrowing
      )

      if self.gp_hef_loan.plans_for_loans.present?
        json.set!(
          'Plans_x0020_for_x0020_Loan',
          active_record_collection_to_array(
            self.gp_hef_loan.plans_for_loans,
            'plan'
          )
        )
      end

      json.set!(
        'Plans_x0020_for_x0020_Loan_x0020',
        self.gp_hef_loan.plans_for_loan_description
      )
      json.set!(
        'Time_x0020_to_x0020_Repay_x0020_',
        self.gp_hef_loan.time_to_repay_loan
      )
      json.set!(
        'Loan_x0020_Amount_x0020_Requeste',
        self.gp_hef_loan.loan_amount_requested
      )

      if self.gp_hef_loan.repayment_frequencies.present?
        json.set!(
          'Repayment_x0020_Frequency',
          active_record_collection_to_array(
            self.gp_hef_loan.repayment_frequencies,
            'frequency'
          )
        )
      end

      if self.gp_hef_loan.org_income_types.present?
        json.set!(
          'Organisation_x0020_Income_x0020_',
          active_record_collection_to_array(
            self.gp_hef_loan.org_income_types,
            'name'
          )
        )
      end

      json.set!(
        'Other_x0020_Organisation_x0020_I',
        self.gp_hef_loan.custom_org_income_type
      )

      json.set!(
          'Cashflow_x0020_Understanding',
          self.gp_hef_loan.cashflow_understanding ? {
              results: [
                  "Yes, I understand what the cashflow for the organisation " \
                  "applying for a loan needs to demonstrate."
                  ]
              } : ""
      )

      # Declaration details
      json.set!('Form_x0020_Feedback', @declaration_form_feedback)
      json.set!('FOI_x0020_Objections', @declaration_data_and_foi)
      json.set!('Declaration', @declaration_agreed_to_terms) 
      json.set!(
        'User_x0020_Research_x0020_and_x0',
        @declaration_data_protection_and_research
      )
      json.set!('Contact_x0020_Consent', @declaration_contact)
      json.set!('Confirmation', @declaration_confirmation)

    end

  end

  private

  # Method to build an array of specified values from an 
  # ActiveRecord::Collection.
  #
  # @param [ActiveRecord::Collection] active_record_collection An instance of
  #                                                            ActiveRecord::Collection
  # @param [String]                   item_key                 A reference to an item key
  def active_record_collection_to_array(active_record_collection, item_key)
      temp_array = []

      active_record_collection.each do |active_record_item|
          temp_array.append(active_record_item[item_key])
      end

      return {results: temp_array}
  end

  # Method to initialise instance variables containing the response to each 
  # declaration question within the COVID-19 Recovery Loans form.  Question response
  # will be the applicants response. 
  #
  # Check box answers are sent to Sharepoint in a results group. 
  # Normal text answers can be sent as they are.
  #
  # @param [ActiveRecord::Collection] active_record_collection An instance of
  #                                                            ActiveRecord::Collection
  def get_declarations(active_record_collection)

    active_record_collection.each do |active_record_item|

      question_response = active_record_item.json['question_response']

      case active_record_item.declaration_type
        when 'agreed_to_terms'
          @declaration_agreed_to_terms = question_response ? 
            {results: [question_response]} : {results: [""]}
        when 'data_protection_and_research'
          @declaration_data_protection_and_research = question_response ? 
            {results: [question_response]} : {results: [""]}
        when 'contact'
          @declaration_contact = question_response ? 
            {results: [question_response]} : {results: [""]}
        when 'confirmation'
          @declaration_confirmation = question_response ? 
            {results: [question_response]} : {results: [""]}
        when 'form_feedback'
          @declaration_form_feedback = question_response
        when 'data_and_foi'
          @declaration_data_and_foi = question_response
      end

    end

  end

end

