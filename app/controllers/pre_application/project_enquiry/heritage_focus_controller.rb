# Controller for the Pre-application 'Start' page
class PreApplication::ProjectEnquiry::HeritageFocusController < ApplicationController
  include PreApplicationContext, ObjectErrorsLogger

  # This method updates the heritage_focus attribute of a project,
  # redirecting to :pre_application_project_enquiry_what_will_the_project_do if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info 'Updating heritage_focus for ' \
                "pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

    @pre_application.pa_project_enquiry.validate_heritage_focus = true

    @pre_application.pa_project_enquiry.update(pa_project_enquiry_params)

    if @pre_application.pa_project_enquiry.valid?

      logger.info 'Finished updating heritage_focus for pa_project_enquiry ID: ' \
                  "#{@pre_application.pa_project_enquiry.id}"

      redirect_to(:pre_application_project_enquiry_what_will_the_project_do)

    else

      logger.info 'Validation failed when attempting to update heritage_focus ' \
                  " for pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

      log_errors(@pre_application.pa_project_enquiry)

      render(:show)

    end
  
  end

  def pa_project_enquiry_params

    params.require(:pa_project_enquiry).permit(:heritage_focus)

  end
  
end
