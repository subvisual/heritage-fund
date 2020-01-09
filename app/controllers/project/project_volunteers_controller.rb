class Project::ProjectVolunteersController < ApplicationController
  include ProjectContext

  def put
    #TODO: Add validation
    @project.update(project_params)
    redirect_to three_to_ten_k_project_volunteers_path
  end


  def show
    @volunteer = @project.volunteers.build
  end

  private
  def project_params
    params.require(:project).permit(volunteers_attributes: [:description, :hours])
  end

end
