class OrganisationController < ApplicationController
  before_action :authenticate_user!

    def index
    end


def new
    @organisation = Organisation.new
end

def create
  @user = current_user
  @user.organisation = Organisation.create(organisation_params)
  @user.save
  redirect_to '/postcode'
end


def show
  @user = current_user
  @organisation = @user.organisation 
  render :show
end

def update
end

private
  def organisation_params
    params.require(:organisation).permit(:name)
  end

end
