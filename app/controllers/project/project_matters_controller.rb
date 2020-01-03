class Project::ProjectMattersController < ApplicationController
  include ProjectContext

  def show
  end

  def update

    logger.debug "Updating project matter for project ID: #{@project.id}"

    @project.validate_matter = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished setting project matter for project ID: #{@project.id}"

      redirect_to :three_to_ten_k_project_availability_get

    else

      logger.debug "Validation failed when updating project matter for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params

    if !params[:project].present?
      params.merge!({project: {matter: ""}})
    end

    params.require(:project).permit(:matter)

  end

end
