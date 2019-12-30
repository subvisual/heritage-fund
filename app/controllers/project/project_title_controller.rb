class Project::ProjectTitleController < ApplicationController

  before_action { @project = Project.new(user: current_user) }

  def show
  end

  def put
    @project.update!(project_params)
    redirect_to three_to_ten_k_project_project_support_evidence_path(@project.id)
  end


  def project_params
    params.require(:project).permit(:project_title)
  end
end
