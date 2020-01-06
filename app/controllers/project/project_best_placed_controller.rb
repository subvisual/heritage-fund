class Project::ProjectBestPlacedController < ApplicationController
  include ProjectContext

  def update

    logger.debug "Updating project best_placed_description for project ID: #{@project.id}"

    @project.validate_best_placed_description = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished setting project best_placed_description for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_involvement_get

    else

      logger.debug "Validation failed when updating project best_placed_description for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params

    if !params[:project].present?
      params.merge!({project: {best_placed_description: ""}})
    end

    params.require(:project).permit(:best_placed_description)

  end
end
