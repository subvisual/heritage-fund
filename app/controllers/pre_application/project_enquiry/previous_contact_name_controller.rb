# Controller for the Pre-application 'previous contact name' page
class PreApplication::ProjectEnquiry::PreviousContactNameController < ApplicationController
  include PreApplicationContext, ObjectErrorsLogger

  # This method updates the previous_contact_name attribute of a project,
  # redirecting to :pre_application_project_enquiry_heritage_focus if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info 'Updating previous_contact_name for ' \
                "pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

    @pre_application.pa_project_enquiry.update(pa_project_enquiry_params)

    if @pre_application.pa_project_enquiry.valid?

      logger.info 'Finished updating previous_contact_name for pa_project_enquiry ID: ' \
                  "#{@pre_application.pa_project_enquiry.id}"

      redirect_to(
        pre_application_project_enquiry_heritage_focus_path(
          @pre_application.id
        )
      )

    else

      logger.info 'Validation failed when attempting to update previous_contact_name ' \
                  " for pa_project_enquiry ID: #{@pre_application.pa_project_enquiry.id}"

      log_errors(@pre_application.pa_project_enquiry)

      render(:show)

    end
  
  end

  def pa_project_enquiry_params

    params.require(:pa_project_enquiry).permit(:previous_contact_name)

  end
  
end
