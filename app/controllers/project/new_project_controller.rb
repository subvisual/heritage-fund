class Project::NewProjectController < ApplicationController
  before_action :authenticate_user!

  def new_project
  end

  # TODO: This is a temporary method to create a new project in order to
  #       pass this to later routes. Once this has been wired up properly,
  #       this method can be removed.
  def temp_create_new_project
    project = Project.new(user: current_user)
    project.save
    redirect_to three_to_ten_k_project_title_get_path(project_id: project.id)
  end

end
