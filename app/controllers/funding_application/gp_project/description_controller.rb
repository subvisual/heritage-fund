class FundingApplication::GpProject::DescriptionController < ApplicationController
  include FundingApplicationContext, ObjectErrorsLogger

  # This method updates the description attribute of a project,
  # redirecting to :three_to_ten_k_project_capital_works if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Updating project description for project ID: #{@funding_application.project.id}"

    @funding_application.project.validate_description = true

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      logger.info "Finished updating project description for project ID: " \
                  " #{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_capital_works

    else
      logger.info "Validation failed when attempting to update description " \
                  "for project ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      render :show

    end

  end

  private

  def project_params
    params.require(:project).permit(:description)
  end

end
