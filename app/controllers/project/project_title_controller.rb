class Project::ProjectTitleController < ApplicationController
  include ProjectHelper
  before_action :authenticate_user!, :set_project

  def show
  end

  def update

    @project.validate_title = true

    @project.update(project_params)

    if @project.valid?
      redirect_to three_to_ten_k_project_dates_get_path(@project.id)
    else
      render :show
    end

  end

  private

  def project_params
    params.require(:project).permit(:project_title)
  end

end
