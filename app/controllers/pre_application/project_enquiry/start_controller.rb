# Controller for the Pre-application 'Start' page
class PreApplication::ProjectEnquiry::StartController < ApplicationController
  before_action :authenticate_user!

  # Method used to create new PreApplication and PaProjectEnquiry objects
  # before redirecting the user to 
  # :pre_application_pa_project_enquiry_previous_contact_path
  def update
  
    @pre_application = PreApplication.create(
      organisation_id: current_user.organisations.first.id
    )
  
    PaProjectEnquiry.create(pre_application_id: @pre_application.id)
  
    redirect_to(
      pre_application_project_enquiry_previous_contact_path(
        @pre_application.id
      )
    )
  
  end

end
