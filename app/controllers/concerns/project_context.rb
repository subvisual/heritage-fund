module ProjectContext
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!, :set_project
  end

  # This method retrieves a project object based on the id
  # found in the URL parameters and the current authenticated
  # user's id, setting it as an instance variable for use in
  # project-related controllers.
  #
  # If no project object matching the parameters is found,
  # then the user is redirected to the projects dashboard.
  def set_project

    @project = Project.find_by(id: params[:project_id], user_id: current_user.id)

    if !@project.present? || ( @project.submitted_on.present? &&
        !request.path.include?("/application-submitted"))
      redirect_to :authenticated_root
    end

  end

end