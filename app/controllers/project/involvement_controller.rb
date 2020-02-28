class Project::InvolvementController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method updates the involvement_description attribute of a project,
  # redirecting to :three_to_ten_k_project_other_outcomes if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Updating involvement_description for project " \
                "ID: #{@project.id}"

    @project.validate_involvement_description = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished updating project involvement_description for " \
                  "project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_other_outcomes_get

    else

      logger.info "Validation failed when attempting to update " \
                  "involvement_description for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({project: {involvement_description: ""}})
    end

    params.require(:project).permit(:involvement_description)

  end

end
