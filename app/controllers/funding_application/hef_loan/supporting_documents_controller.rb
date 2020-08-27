# Controller for the COVID-19 Recovery Loan 'Application submitted' page
class FundingApplication::HefLoan::SupportingDocumentsController < ApplicationController
  include FundingApplicationContext
  include ObjectErrorsLogger

  # This method is used to set the @has_file_upload instance variable before
  # rendering the :show template. This is used within the
  # _direct_file_upload_hooks partial
  def show
    @has_file_upload = true
  end

  # This method updates the supporting_documents_files attribute of a GpHefLoan,
  # redirecting to :funding_application_hef_loan_supporting_documents
  # if successful and re-rendering :show method if unsuccessful
  def update

    logger.info 'Updating supporting_documents_files for funding_application ' \
                "ID: #{@funding_application.id} and gp_hef_loan ID: " \
                "#{@funding_application.gp_hef_loan.id}"

    @funding_application.gp_hef_loan.validate_supporting_documents_files = true

    # If a 'complete' param has been passed, then there is no need to update the
    # model object
    @funding_application.update(funding_application_params) unless params.key? 'complete'

    validate_funding_application_and_orchestrate_journey(
      @funding_application,
      params.key?('complete') ? 'progress_journey' : 'add_file'
    )

  end

  private

  # Method to validate the model object and dictate the next steps of the journey
  # based on whether or not the model object was valid
  def validate_funding_application_and_orchestrate_journey(funding_application, user_action)

    if funding_application.valid?

      logger.info 'Finished updating supporting_documents_files for ' \
                  "funding_application ID: #{funding_application.id}" \
                  "and gp_hef_loan ID: #{funding_application.gp_hef_loan.id}"

      # If the user was adding a file, then they should be redirected back to
      # the same page, otherwise continue on to the next page of the journey
      redirect_to user_action == 'add_file' ?
        :funding_application_hef_loan_supporting_documents :
        :funding_application_hef_loan_declaration

    else

      logger.info 'Validation failed when attempting to update ' \
                  'supporting_documents_files for funding_application ' \
                  "ID: #{funding_application.id} and gp_hef_loan ID: " \
                  "#{funding_application.gp_hef_loan.id}"

      log_errors(funding_application)

      render :show

    end

  end

  def funding_application_params

    # If no form interaction has taken place, no parameter will be sent through.
    # We manually inject the necessary parameter here in order to trigger a
    # validation failure
    unless params[:funding_application].present?
      params.merge!(
        {
          funding_application: {
            gp_hef_loan_attributes: {
              supporting_documents_files: nil
            }
          }
        }
      )
    end

    params.require(:funding_application).permit(
      gp_hef_loan_attributes: [
        :id,
        supporting_documents_files: []
      ]
    )

  end

end
