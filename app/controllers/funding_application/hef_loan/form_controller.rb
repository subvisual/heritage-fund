# Controller for the COVID-19 Recovery Loan 'Application form' page
class FundingApplication::HefLoan::FormController < ApplicationController
  include FundingApplicationContext

  def show

    construct_people

    initialise_instance_variables

    build_organisations_org_types
    build_gp_hef_loans_org_income_types
    build_gp_hef_loans_plans_for_loans
    build_gp_hef_loans_repayment_freqs

  end

  def update

    mark_all_attributes_for_validation(params)

    @funding_application.update(funding_application_params)

    if @funding_application.valid?

      @funding_application.save

      redirect_to funding_application_hef_loan_supporting_documents_path(@funding_application.id)

    else

      initialise_instance_variables

      build_organisations_org_types
      build_gp_hef_loans_org_income_types
      build_gp_hef_loans_plans_for_loans
      build_gp_hef_loans_repayment_freqs

      render :show

    end

  end

  private

  # Method for constructing associated Person objects
  # if existing Person objects associated with
  # @funding_application do not exist
  def construct_people

    @funding_application.people.build unless @funding_application.people.first.present?
    @funding_application.people.build unless @funding_application.people.second.present?

  end

  # Method to call necessary methods to initialise all
  # form-related instance variables
  def initialise_instance_variables

    initialise_org_type_instance_variables
    initialise_org_income_type_instance_variables
    initialise_plans_for_loan_instance_variables
    initialise_repayment_frequency_instance_variables

  end

  def initialise_org_type_instance_variables

    @org_type_registered_charity = OrgType.find_by(name: 'Registered charity')
    @org_type_registered_company = OrgType.find_by(name: 'Registered company')
    @org_type_community_interest_company = OrgType.find_by(name: 'Community Interest company')
    @org_type_faith_based_organisation = OrgType.find_by(name: 'Faith-based organisation')
    @org_type_church_organisation = OrgType.find_by(name: 'Church organisation')
    @org_type_community_group = OrgType.find_by(name: 'Community group')
    @org_type_voluntary_group = OrgType.find_by(name: 'Voluntary group')
    @org_type_individual_private_owner_of_heritage = OrgType.find_by(name: 'Individual private owner of heritage')

  end

  def build_organisations_org_types

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_registered_charity.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_registered_charity.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_registered_charity.id
      )

    end

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_registered_company.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_registered_company.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_registered_company.id
      )

    end

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_community_interest_company.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_community_interest_company.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_community_interest_company.id
      )

    end

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_faith_based_organisation.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_faith_based_organisation.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_faith_based_organisation.id
      )

    end

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_church_organisation.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_church_organisation.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_church_organisation.id
      )

    end

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_community_group.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_community_group.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_community_group.id
      )

    end

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_voluntary_group.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_voluntary_group.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_voluntary_group.id
      )

    end

    unless @funding_application.organisation.organisations_org_types.where(
      org_type_id: @org_type_individual_private_owner_of_heritage.id
    ).present? || @funding_application.organisation.organisations_org_types.select { |ot|
      ot.org_type_id == @org_type_individual_private_owner_of_heritage.id
    }.present?

      @funding_application.organisation.organisations_org_types.build(
        org_type_id: @org_type_individual_private_owner_of_heritage.id
      )

    end

  end

  def initialise_plans_for_loan_instance_variables

    @plans_for_loan_cashflow = PlansForLoan.find_by(plan: 'Cashflow')
    @plans_for_loan_staff_salaries = PlansForLoan.find_by(plan: 'Staff salaries')
    @plans_for_loan_working_capital = PlansForLoan.find_by(plan: 'Working capital')
    @plans_for_loan_recovering_planning = PlansForLoan.find_by(plan: 'Recovering planning')

  end

  def build_gp_hef_loans_plans_for_loans

    unless @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.where(
      plans_for_loan_id: @plans_for_loan_cashflow.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.select { |p|
      p.plans_for_loan_id == @plans_for_loan_cashflow.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.build(
        plans_for_loan_id: @plans_for_loan_cashflow.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.where(
      plans_for_loan_id: @plans_for_loan_staff_salaries.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.select { |p|
      p.plans_for_loan_id == @plans_for_loan_staff_salaries.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.build(
        plans_for_loan_id: @plans_for_loan_staff_salaries.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.where(
      plans_for_loan_id: @plans_for_loan_working_capital.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.select { |p|
      p.plans_for_loan_id == @plans_for_loan_working_capital.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.build(
        plans_for_loan_id: @plans_for_loan_working_capital.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.where(
      plans_for_loan_id: @plans_for_loan_recovering_planning.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.select { |p|
      p.plans_for_loan_id == @plans_for_loan_recovering_planning.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_plans_for_loans.build(
        plans_for_loan_id: @plans_for_loan_recovering_planning.id
      )

    end

  end

  def initialise_repayment_frequency_instance_variables

    @repayment_frequency_monthly = RepaymentFrequency.find_by(frequency: 'Monthly')
    @repayment_frequency_quarterly = RepaymentFrequency.find_by(frequency: 'Quarterly')
    @repayment_frequency_yearly = RepaymentFrequency.find_by(frequency: 'Yearly')

  end

  def build_gp_hef_loans_repayment_freqs

    unless @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.where(
      repayment_frequency_id: @repayment_frequency_monthly.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.select { |rf|
      rf.repayment_frequency_id == @repayment_frequency_monthly.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.build(
        repayment_frequency_id: @repayment_frequency_monthly.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.where(
      repayment_frequency_id: @repayment_frequency_quarterly.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.select { |rf|
      rf.repayment_frequency_id == @repayment_frequency_quarterly.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.build(
        repayment_frequency_id: @repayment_frequency_quarterly.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.where(
      repayment_frequency_id: @repayment_frequency_yearly.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.select { |rf|
      rf.repayment_frequency_id == @repayment_frequency_yearly.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_repayment_freqs.build(
        repayment_frequency_id: @repayment_frequency_yearly.id
      )

    end

  end

  # This method initialises individual instance variables for each static
  # organisation income type, which can then be referenced from the
  # corresponding view. By referencing these instance variables, we no
  # longer have to lookup the static organisation income type unique
  # identifiers multiple times from the corresponding view
  def initialise_org_income_type_instance_variables

    @org_income_type_government_contract = OrgIncomeType.find_by(name: 'Government contract')
    @org_income_type_rental_income = OrgIncomeType.find_by(name: 'Rental Income')
    @org_income_type_membership_fees = OrgIncomeType.find_by(name: 'Membership fees')
    @org_income_type_grants = OrgIncomeType.find_by(name: 'Grants')
    @org_income_type_donations = OrgIncomeType.find_by(name: 'Donations')
    @org_income_type_trading = OrgIncomeType.find_by(name: 'Trading')

  end

  # Method for building individual GpHefLoansOrgIncomeType objects for
  # each static organisation income type - only if the objects do not
  # already exist
  def build_gp_hef_loans_org_income_types

    unless @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.where(
      org_income_type_id: @org_income_type_government_contract.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.select { |oit|
      oit.org_income_type_id == @org_income_type_government_contract.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.build(
        org_income_type_id: @org_income_type_government_contract.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.where(
      org_income_type_id: @org_income_type_rental_income.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.select { |oit|
      oit.org_income_type_id == @org_income_type_rental_income.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.build(
        org_income_type_id: @org_income_type_rental_income.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.where(
      org_income_type_id: @org_income_type_membership_fees.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.select { |oit|
      oit.org_income_type_id == @org_income_type_membership_fees.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.build(
        org_income_type_id: @org_income_type_membership_fees.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.where(
      org_income_type_id: @org_income_type_grants.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.select { |oit|
      oit.org_income_type_id == @org_income_type_grants.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.build(
        org_income_type_id: @org_income_type_grants.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.where(
      org_income_type_id: @org_income_type_donations.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.select { |oit|
      oit.org_income_type_id == @org_income_type_donations.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.build(
        org_income_type_id: @org_income_type_donations.id
      )

    end

    unless @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.where(
      org_income_type_id: @org_income_type_trading.id
    ).present? || @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.select { |oit|
      oit.org_income_type_id == @org_income_type_trading.id
    }.present?

      @funding_application.gp_hef_loan.gp_hef_loans_org_income_types.build(
        org_income_type_id: @org_income_type_trading.id
      )

    end

  end

  # This method sets the model validation flags on all required model attributes
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def mark_all_attributes_for_validation(request_params)

    @funding_application.organisation.validate_name = true
    validate_custom_org_type(request_params)
    @funding_application.gp_hef_loan.validate_previous_project_reference = true
    @funding_application.gp_hef_loan.validate_can_legally_take_on_debt = true
    validate_any_debt_restrictions(request_params)
    validate_debt_description(request_params)
    @funding_application.gp_hef_loan.validate_can_provide_security = true
    validate_security_restrictions(request_params)
    validate_security_description(request_params)
    @funding_application.gp_hef_loan.validate_has_had_an_average_yearly_cash_surplus = true
    validate_average_yearly_cash_surplus(request_params)
    @funding_application.gp_hef_loan.validate_has_had_a_surplus_in_last_reporting_year = true
    validate_cash_surplus_in_last_year(request_params)
    validate_custom_org_income_type(request_params)
    @funding_application.gp_hef_loan.validate_bankruptcy_or_administration = true
    validate_bankruptcy_or_administration_description(request_params)
    @funding_application.gp_hef_loan.validate_considers_state_aid = true
    @funding_application.gp_hef_loan.validate_has_applied_for_grant_or_loan = true
    validate_other_funding_details(request_params)
    @funding_application.gp_hef_loan.validate_efforts_to_reduce_borrowing = true
    @funding_application.gp_hef_loan.validate_plans_for_loan_description = true
    @funding_application.gp_hef_loan.validate_loan_amount_requested = true
    @funding_application.gp_hef_loan.validate_time_to_repay_loan = true
    @funding_application.gp_hef_loan.validate_cashflow_understanding = true
    @funding_application.validate_people = true

    @funding_application.people.each do |p|
      p.validate_name = true
      p.validate_position = true
      p.validate_email = true
      p.validate_phone_number = true
    end

  end

  # Only validate :custom_org_type if :has_custom_org_type has been checked
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_custom_org_type(request_params)

    if request_params.dig(
      :funding_application,
      :organisation_attributes,
      :has_custom_org_type
    ) == 'true'

      @funding_application.organisation.validate_custom_org_type = true

    end

  end

  # Only validate :any_debt_restrictions if :can_legally_take_on_debt has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_any_debt_restrictions(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :can_legally_take_on_debt
    ) == 'true'

      @funding_application.gp_hef_loan.validate_any_debt_restrictions = true

    end

  end

  # Only validate :debt_description if :any_debt_restrictions has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_debt_description(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :any_debt_restrictions
    ) == 'true'

      @funding_application.gp_hef_loan.validate_debt_description = true

    end

  end

  # Only validate :security_restrictions if :can_provide_security has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_security_restrictions(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :can_provide_security
    ) == 'true'

      @funding_application.gp_hef_loan.validate_security_restrictions = true

    end

  end

  # Only validate :security_description if :security_restrictions has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_security_description(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :security_restrictions
    ) == 'true'

      @funding_application.gp_hef_loan.validate_security_description = true

    end

  end

  # Only validate :average_yearly_cash_surplus if :has_had_an_average_yearly_cash_surplus
  # has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_average_yearly_cash_surplus(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :has_had_an_average_yearly_cash_surplus
    ) == 'true'

      @funding_application.gp_hef_loan.validate_average_yearly_cash_surplus = true

    end

  end

  # Only validate :cash_surplus_in_last_year if :has_had_a_surplus_in_last_reporting_year
  # has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_cash_surplus_in_last_year(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :has_had_a_surplus_in_last_reporting_year
    ) == 'true'

      @funding_application.gp_hef_loan.validate_cash_surplus_in_last_year = true

    end

  end

  # Only validate :custom_org_income_type if :has_custom_org_income_type has been checked
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_custom_org_income_type(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :has_custom_org_income_type
    ) == 'true'

      @funding_application.gp_hef_loan.validate_custom_org_income_type = true

    end

  end

  # Only validate :bankruptcy_or_administration_description if :bankruptcy_or_administration
  # has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_bankruptcy_or_administration_description(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :bankruptcy_or_administration
    ) == 'true'

      @funding_application.gp_hef_loan.validate_bankruptcy_or_administration_description = true

    end

  end

  # Only validate :other_funding_details if :has_applied_for_grant_or_loan has been set to 'Yes'
  # @param [ActionController::Parameters] request_params The params object sent
  #                                                      in the request
  def validate_other_funding_details(request_params)

    if request_params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :has_applied_for_grant_or_loan
    ) == 'true'

      @funding_application.gp_hef_loan.validate_other_funding_details = true

    end

  end

  def funding_application_params

    unless params[:funding_application][:gp_hef_loan_attributes][:cashflow_understanding].present?
      params[:funding_application][:gp_hef_loan_attributes][:cashflow_understanding] = false
    end

    params.dig(
      :funding_application,
      :organisation_attributes,
      :organisations_org_types_attributes
    )&.each do |org_type|

      # org_type here is an array, where the first element is a string containing
      # the element position within the wider params, and the second element is an
      # additional set of params

      # If the second array element (the params) contains a key of 'org_type_id', then we know
      # that it has been unchecked on the form and can therefore be marked for deletion
      if org_type[1].key?('id')

        unless org_type[1].key?('org_type_id')

          # We merge an additional key/value pair into the params to flag this
          # particular element for deletion, as Rails doesn't do this for us
          org_type[1].merge!({ '_destroy': 1 })

        end

      end

    end

    params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :gp_hef_loans_org_income_types_attributes
    )&.each do |org_income_type|

      # org_income_type here is an array, where the first element is a string containing
      # the element position within the wider params, and the second element is an
      # additional set of params

      # If the second array element (the params) contains a key of 'org_income_type_id', then we know
      # that it has been unchecked on the form and can therefore be marked for deletion

      if org_income_type[1].key?('id')

        unless org_income_type[1].key?('org_income_type_id')

          # We merge an additional key/value pair into the params to flag this
          # particular element for deletion, as Rails doesn't do this for us
          org_income_type[1].merge!({ '_destroy': 1 })

        end

      end

    end

    params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :gp_hef_loans_repayment_freqs_attributes
    )&.each do |repayment_frequency|

      # repayment_frequency here is an array, where the first element is a string containing
      # the element position within the wider params, and the second element is an
      # additional set of params

      # If the second array element (the params) contains a key of 'repayment_frequency_id', then we know
      # that it has been unchecked on the form and can therefore be marked for deletion
      if repayment_frequency[1].key?('id')

        unless repayment_frequency[1].key?('repayment_frequency_id')

          # We merge an additional key/value pair into the params to flag this
          # particular element for deletion, as Rails doesn't do this for us
          repayment_frequency[1].merge!({ '_destroy': 1 })

        end

      end

    end

    params.dig(
      :funding_application,
      :gp_hef_loan_attributes,
      :gp_hef_loans_plans_for_loans_attributes
    )&.each do |plan_for_loan|

      # plan_for_loan here is an array, where the first element is a string containing
      # the element position within the wider params, and the second element is an
      # additional set of params

      # If the second array element (the params) contains a key of 'plans_for_loan_id', then we know
      # that it has been unchecked on the form and can therefore be marked for deletion
      if plan_for_loan[1].key?('id')

        unless plan_for_loan[1].key?('plans_for_loan_id')

          # We merge an additional key/value pair into the params to flag this
          # particular element for deletion, as Rails doesn't do this for us
          plan_for_loan[1].merge!({ '_destroy': 1 })

        end

      end

    end

    params.require(:funding_application)
          .permit(
            gp_hef_loan_attributes: [
              :previous_project_reference,
              :can_legally_take_on_debt,
              :any_debt_restrictions,
              :debt_description,
              :can_provide_security,
              :security_restrictions,
              :security_description,
              :has_had_an_average_yearly_cash_surplus,
              :average_yearly_cash_surplus,
              :has_had_a_surplus_in_last_reporting_year,
              :cash_surplus_in_last_year,
              :bankruptcy_or_administration,
              :bankruptcy_or_administration_description,
              :considers_state_aid,
              :has_applied_for_grant_or_loan,
              :other_funding_details,
              :efforts_to_reduce_borrowing,
              :plans_for_loan_description,
              :time_to_repay_loan,
              :cashflow_understanding,
              :loan_amount_requested,
              :id,
              :custom_org_income_type,
              :has_custom_org_income_type,
              gp_hef_loans_org_income_types_attributes: [
                :org_income_type_id,
                :_destroy,
                :id
              ],
              gp_hef_loans_plans_for_loans_attributes: [
                :plans_for_loan_id,
                :_destroy,
                :id
              ],
              gp_hef_loans_repayment_freqs_attributes: [
                :repayment_frequency_id,
                :_destroy,
                :id
              ],
              plans_for_loans: [:plan],
              repayment_frequencies: [:frequency],
              org_income_types: [:name]
            ],
            people_attributes: [
              :name,
              :email,
              :position,
              :phone_number,
              :id
            ],
            organisation_attributes: [
              :name,
              :custom_org_type,
              :id,
              :has_custom_org_type,
              organisations_org_types_attributes: [
                :org_type_id,
                :_destroy,
                :id
              ]
            ]
          )

  end

end
