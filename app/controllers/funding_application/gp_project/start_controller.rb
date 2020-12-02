# Controller for the Project 'Start' page
class FundingApplication::GpProject::StartController < ApplicationController
  before_action :authenticate_user!

  # Method used to create new FundingApplication and Project objects
  # before redirecting the user to :funding_application_project_application_form
  def update

    @application = FundingApplication.create(
      organisation_id: current_user.organisations.first.id
    )

    Project.create(funding_application_id: @application.id, user: current_user)

    redirect_to(
      funding_application_gp_project_title_path(
        @application.id
      )
    )

  end

end
