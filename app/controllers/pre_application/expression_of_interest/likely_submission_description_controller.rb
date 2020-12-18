# Controller for the Pre-application 'Start' page
class PreApplication::ExpressionOfInterest::LikelySubmissionDescriptionController < ApplicationController
  include PreApplicationContext, ObjectErrorsLogger
  
  # This method updates the likely_submission_description attribute of a project,
  # redirecting to :pre_application_project_enquiry_likely_cost if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info 'Updating likely_submission_description for ' \
                "pa_expression_of_interest ID: #{@pre_application.pa_expression_of_interest.id}"

    @pre_application.pa_expression_of_interest.validate_likely_submission_description = true

    @pre_application.pa_expression_of_interest.update(pa_expression_of_interest_params)

    if @pre_application.pa_expression_of_interest.valid?

      logger.info 'Finished updating likely_submission_description for pa_expression_of_interest ID: ' \
                  "#{@pre_application.pa_expression_of_interest.id}"
      
      the_json = @pre_application.to_salesforce_json

      logger.info(the_json)

      redirect_to(:pre_application_project_enquiry_submitted)

    else

      logger.info 'Validation failed when attempting to update likely_submission_description ' \
                  " for pa_expression_of_interest ID: #{@pre_application.pa_expression_of_interest.id}"

      log_errors(@pre_application.pa_expression_of_interest)

      render(:show)

    end
  
  end

  def pa_expression_of_interest_params

    params.require(:pa_expression_of_interest).permit(:likely_submission_description)

  end
    
end
