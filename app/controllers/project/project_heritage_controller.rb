class Project::ProjectHeritageController < ApplicationController
  include ProjectContext

  def update

    logger.debug "Updating project heritage description for project ID: #{@project.id}"

    @project.validate_heritage_description = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished setting project heritage description for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_best_placed_get

    else

      logger.debug "Validation failed when updating project heritage description for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params

    if !params[:project].present?
      params.merge!({project: {heritage_description: ""}})
    end

    params.require(:project).permit(:heritage_description)

  end

end
