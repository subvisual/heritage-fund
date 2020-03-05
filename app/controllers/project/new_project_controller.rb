class Project::NewProjectController < ApplicationController
  before_action :authenticate_user!

  # This method creates a new project and then redirects the
  # to :three_to_ten_k_project_title_get
  def create_new_project

    logger.info "User ID: #{current_user.id} has selected to start a " \
                "new project"

    @project = Project.new(user: current_user)
    @project.save

    logger.info "Project created for user ID: #{current_user.id} with ID: " \
                "#{@project.id}"

    redirect_to three_to_ten_k_project_title_get_path(project_id: @project.id)

  end

end
