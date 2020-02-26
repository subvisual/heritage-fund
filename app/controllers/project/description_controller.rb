class Project::DescriptionController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method updates the description attribute of a project,
  # redirecting to :three_to_ten_k_project_capital_works if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Updating project description for project ID: #{@project.id}"

    @project.validate_description = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished updating project description for project ID: " \
                  " #{@project.id}"

      redirect_to :three_to_ten_k_project_capital_works_get

    else

      logger.info "Validation failed when attempting to update description " \
                  "for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params
    params.require(:project).permit(:description)
  end

end
