module ProjectContext
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!, :set_project
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

end