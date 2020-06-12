class Project::StartController < ApplicationController
  before_action :authenticate_user!
end
