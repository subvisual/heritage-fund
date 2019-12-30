module ProjectHelper

  def set_project
    @project = Project.find(params[:project_id])
  end
end
