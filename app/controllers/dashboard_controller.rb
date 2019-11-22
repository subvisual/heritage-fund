class DashboardController < ApplicationController

  def show
    @user = User.find_by(uid: session[:user_id])
  end
  
end