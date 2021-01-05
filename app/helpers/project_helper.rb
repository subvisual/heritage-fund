module ProjectHelper
  # Helper method to set the project instance variable equal
  # to the project identifier within the current params
  def set_project
    @project = Project.find(params[:project_id])
  end
end
