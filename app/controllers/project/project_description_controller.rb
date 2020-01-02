class Project::ProjectDescriptionController < ApplicationController
  include ProjectHelper
  before_action :authenticate_user!, :set_project

  def show
  end

  def update

    logger.debug "Updating project description for project ID: #{@project.id}"

    @project.validate_description = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished updating project description for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_capital_works_get_path(@project.id)

    else

      logger.debug "Validation failed for project description for project ID: #{@project.id}"

      render :show

    end

  end

  private

  def project_params
    params.require(:project).permit(:description)
  end

end
