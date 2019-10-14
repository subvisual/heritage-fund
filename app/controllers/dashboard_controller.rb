class DashboardController < ApplicationController
  include Secured

  def show
    @user = User.find_by(uid: session[:user_id])
  end

  
end