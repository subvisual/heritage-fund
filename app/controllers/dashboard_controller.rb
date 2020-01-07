class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show

    @projects = Project.all.where(user_id: current_user.id)

  end
  
end