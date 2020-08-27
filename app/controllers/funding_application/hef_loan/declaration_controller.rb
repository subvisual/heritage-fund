# Controller responsible for handling COVID-19 Recovery Loan declaration-related pages
class FundingApplication::HefLoan::DeclarationController < ApplicationController
  include FundingApplicationContext

  # Build five declaration instances and assign type. Only certain types are mandatory.
  # Mandatory Types are agreed_to_terms and has_authority
  # Optional types are foi_objections, agreed_to_user_research, wants_to_be_kept_informed, form_feedback
  def show

    build_agreed_to_terms(question_response: nil)
    build_data_and_foi(question_response: nil)
    build_data_protection_and_research(question_response: nil)
    build_contact(question_response: nil)
    build_confirmation(question_response: nil)
    build_form_feedback(question_response: nil)

  end

  def update

    @funding_application.validate_declarations = true

    @funding_application.update(funding_application_params)

    if @funding_application.valid?

      build_agreed_to_terms(params)
      build_data_and_foi(params)
      build_data_protection_and_research(params)
      build_contact(params)
      build_confirmation(params)
      build_form_feedback(params)

      agreed_to_terms = agreed_to_terms?(@funding_application.declarations.first)
      expressed_confirmation = expressed_confirmation?(@funding_application.declarations.fifth)

      if agreed_to_terms && expressed_confirmation

        @funding_application.save

        ApplicationToSharepointJob.perform_later(@funding_application)

        logger.info "Redirecting to HEF Loan application submitted path for user ID: #{current_user.id}"

        redirect_to funding_application_hef_loan_application_submitted_path(@funding_application.id)

      else

        render :show

      end

    else

      render :show

    end

  end

  private

  # If no form interaction has taken place, no parameter will be sent through.
  # We manually inject the necessary parameter here in order to trigger a
  # validation failure
  def funding_application_params

    unless params[:funding_application].present?

      params.merge!(
        {
          funding_application: {
            declarations_attributes: {}
          }
        }
      )

    end

    params.require(:funding_application)
          .permit(
            :declarations_attributes,
            :applicants_response
          )

  end

  def build_agreed_to_terms(request_params)

    unless @funding_application.declarations.first.present?
      first = @funding_application.declarations.build
      first.grant_programme = 'gp_hef_loan'
      first.declaration_type = 'agreed_to_terms'
      first.version = 1
    end

    question_response = request_params&.dig(
      :funding_application,
      :declarations_attributes,
      :"0",
      :agreed_to_terms
    )

    @funding_application.declarations.first.json = {
      text: I18n.t('hef_loan_declarations_form.text.agreed_to_terms'),
      question: I18n.t('hef_loan_declarations_form.questions.agreed_to_terms'),
      question_response: question_response
    }

  end

  def agreed_to_terms?(agreed_to_terms_declaration)

    # specific error checking for this instance of declaration. Which is why the checking is here - not in the model
    unless agreed_to_terms_declaration.json.present? && agreed_to_terms_declaration.json['question_response'].present?

      agreed_to_terms_declaration.errors[:agreed_to_terms] <<
        I18n.t('hef_loan_declarations_form.errors.agreed_to_terms')

      return false

    end

    true

  end

  def expressed_confirmation?(confirmation_declaration)

    # specific error checking for this instance of declaration. Which is why the checking is here - not in the model
    unless confirmation_declaration.json.present? && confirmation_declaration.json['question_response'].present?

      confirmation_declaration.errors[:confirmation] << I18n.t('hef_loan_declarations_form.errors.confirmation')

      return false

    end

    true

  end

  def build_data_and_foi(request_params)

    unless @funding_application.declarations.second.present?
      second = @funding_application.declarations.build
      second.grant_programme = 'gp_hef_loan'
      second.declaration_type = 'data_and_foi'
      second.version = 1
    end

    # applicants_response is an attr_accessor
    applicants_response = request_params&.dig(
      :funding_application,
      :declarations_attributes,
      :"1",
      :applicants_response
    )
    @funding_application.declarations.second.applicants_response = applicants_response

    @funding_application.declarations.second.json = {
      text: I18n.t('hef_loan_declarations_form.text.data_and_foi'),
      question: I18n.t('hef_loan_declarations_form.questions.data_and_foi'),
      question_response: applicants_response
    }

  end

  def build_data_protection_and_research(request_params)

    unless @funding_application.declarations.third.present?
      third = @funding_application.declarations.build
      third.grant_programme = 'gp_hef_loan'
      third.declaration_type = 'data_protection_and_research'
      third.version = 1
    end

    question_response = request_params&.dig(
      :funding_application,
      :declarations_attributes,
      :"2",
      :data_protection_and_research
    )

    @funding_application.declarations.third.json = {
      text: I18n.t('hef_loan_declarations_form.text.data_protection_and_research'),
      question: I18n.t('hef_loan_declarations_form.questions.data_protection_and_research'),
      question_response: question_response
    }

  end

  def build_contact(request_params)

    unless @funding_application.declarations.fourth.present?
      fourth = @funding_application.declarations.build
      fourth.grant_programme = 'gp_hef_loan'
      fourth.declaration_type = 'contact'
      fourth.version = 1
    end

    question_response = request_params&.dig(
      :funding_application,
      :declarations_attributes,
      :"3",
      :contact
    )

    @funding_application.declarations.fourth.json = {
      text: I18n.t('hef_loan_declarations_form.text.contact'),
      question: I18n.t('hef_loan_declarations_form.questions.contact'),
      question_response: question_response
    }
  end

  def build_confirmation(request_params)

    unless @funding_application.declarations.fifth.present?
      fifth = @funding_application.declarations.build
      fifth.grant_programme = 'gp_hef_loan'
      fifth.declaration_type = 'confirmation'
      fifth.version = 1
    end

    question_response = request_params&.dig(
      :funding_application,
      :declarations_attributes,
      :"4",
      :confirmation
    )

    @funding_application.declarations.fifth.json = {
      text: I18n.t('hef_loan_declarations_form.text.confirmation'),
      question: I18n.t('hef_loan_declarations_form.questions.confirmation'),
      question_response: question_response
    }

  end

  def build_form_feedback(request_params)

    unless @funding_application.declarations[5].present?
      sixth = @funding_application.declarations.build
      sixth.grant_programme = 'gp_hef_loan'
      sixth.declaration_type = 'form_feedback'
      sixth.version = 1
    end

    applicants_response = request_params&.dig(
      :funding_application,
      :declarations_attributes,
      :"5",
      :applicants_response
    )

    # applicants_response is an attr_accessor
    @funding_application.declarations[5].applicants_response = applicants_response

    @funding_application.declarations[5].json = {
      text: I18n.t('hef_loan_declarations_form.text.form_feedback'),
      question: I18n.t('hef_loan_declarations_form.questions.form_feedback'),
      question_response: applicants_response
    }

  end

end
