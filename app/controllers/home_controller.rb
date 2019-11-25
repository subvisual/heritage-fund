class HomeController < ApplicationController

  before_action :authenticate_user!
  
  def show
    redirect_to '/dashboard'
  end
end
