# Controller for the Pre-application 'Start' page
class PreApplication::ProjectEnquiry::PotentialFundingAmountController < ApplicationController
  include PreApplicationContext, ObjectErrorsLogger
  
  # This method updates the potential_funding_amount attribute of a project,
  # redirecting to :pre_application_project_enquiry_likely_cost if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info 'Updating potential_funding_amount for ' \
                "pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

    @pre_application.pa_project_enquiry.validate_potential_funding_amount = true

    @pre_application.pa_project_enquiry.update(pa_project_enquiry_params)

    if @pre_application.pa_project_enquiry.valid?

      logger.info 'Finished updating potential_funding_amount for pa_project_enquiry ID: ' \
                  "#{@pre_application.pa_project_enquiry.id}"

      redirect_to(pre_application_project_enquiry_submitted_path)

    else

      logger.info 'Validation failed when attempting to update potential_funding_amount ' \
                  " for pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

      log_errors(@pre_application.pa_project_enquiry)

      render(:show)

    end
  
  end

  def pa_project_enquiry_params

    params.require(:pa_project_enquiry).permit(:potential_funding_amount)

  end
    
end
