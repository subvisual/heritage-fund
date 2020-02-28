class Project::HeritageController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method updates the heritage_description attribute of a project,
  # redirecting to :three_to_ten_k_project_best_placed_get if successful and
  # re-rendering :show method if unsuccessful
  def update

    logger.info "Updating heritage_description for project ID: #{@project.id}"

    @project.validate_heritage_description = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished updating heritage_description for project " \
                   "ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_best_placed_get

    else

      logger.info "Validation failed when attempting to update " \
                  "heritage_description for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({project: {heritage_description: ""}})
    end

    params.require(:project).permit(:heritage_description)

  end

end
