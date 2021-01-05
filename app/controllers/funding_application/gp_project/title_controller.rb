# Controller for the project title page of the funding application journey
class FundingApplication::GpProject::TitleController < ApplicationController
  include FundingApplicationContext
  include ObjectErrorsLogger

  # This method updates the project_title attribute of a project,
  # redirecting to :three_to_ten_k_project_key_dates if successful and
  # re-rendering :show method if unsuccessful
  def update
    logger.info "Updating project_title for project ID: #{@funding_application.project.id}"

    @funding_application.project.validate_title = true

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      logger.info "Finished updating project_title for project ID: " \
                  "#{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_key_dates

    else

      logger.info "Validation failed when attempting to update project_title " \
                  " for project ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      render :show

    end
  end

  private

  def project_params
    params.require(:project).permit(:project_title)
  end
end
