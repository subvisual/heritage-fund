class Project::ProjectDifferenceController < ApplicationController
  include ProjectContext

  def show
  end

  def update

    logger.debug "Updating project difference for project ID: #{@project.id}"

    @project.validate_difference = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished setting project difference for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_matter_get

    else

      logger.debug "Validation failed when updating project difference for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params

    if !params[:project].present?
      params.merge!({project: {difference: ""}})
    end

    params.require(:project).permit(:difference)

  end
end
