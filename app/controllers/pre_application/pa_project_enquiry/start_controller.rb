# Controller for the Pre-application 'Start' page
class PreApplication::PaProjectEnquiry::StartController < ApplicationController
  before_action :authenticate_user!

  # Method used to create new PreApplication and PaProjectEnquiry objects
  # before redirecting the user to :blah
  def update
  
    @pre_application = PreApplication.create(
      organisation_id: current_user.organisations.first.id
    )
  
    PaProjectEnquiry.create(pre_application_id: @pre_application.id, user: current_user)
  
    redirect_to(
      funding_application_gp_project_title_path(
          @application.id
      )
    )
  
  end

end
