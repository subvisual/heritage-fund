# Controller for the Pre-application 'Start' page
class PreApplication::ProjectEnquiry::WhatProjectDoesController < ApplicationController
  include PreApplicationContext, ObjectErrorsLogger

  # This method updates the what_project_does attribute of a project,
  # redirecting to :pre_application_project_enquiry_what_will_the_project_do if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info 'Updating what_project_does for ' \
                "pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

    @pre_application.pa_project_enquiry.validate_what_project_does = true

    @pre_application.pa_project_enquiry.update(pa_project_enquiry_params)

    if @pre_application.pa_project_enquiry.valid?

      logger.info 'Finished updating what_project_does for pa_project_enquiry ID: ' \
                  "#{@pre_application.pa_project_enquiry.id}"

      redirect_to(:pre_application_project_enquiry_programme_outcomes)

    else

      logger.info 'Validation failed when attempting to update what_project_does ' \
                  " for pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

      log_errors(@pre_application.pa_project_enquiry)

      render(:show)

    end
  
  end

  def pa_project_enquiry_params

    params.require(:pa_project_enquiry).permit(:what_project_does)

  end
end
