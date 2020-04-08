class Project::TitleController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method updates the project_title attribute of a project,
  # redirecting to :three_to_ten_k_project_key_dates if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Updating project_title for project ID: #{@project.id}"

    @project.validate_title = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished updating project_title for project ID: " \
                  "#{@project.id}"

      redirect_to :three_to_ten_k_project_key_dates

    else

      logger.info "Validation failed when attempting to update project_title " \
                  " for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params
    params.require(:project).permit(:project_title)
  end

end
