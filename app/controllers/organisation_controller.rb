class OrganisationController < ApplicationController

    def index
    end


def new
    @organisation = Organisation.new
end

def create
  @user = User.find_by(uid: session[:user_id])
  @user.organisation.update(organisation_params)
  @user.save
  redirect_to '/postcode'
end


def show
  @user = User.find_by(uid: session[:user_id])
  @organisation = @user.organisation 
  render :show
end

private
  def organisation_params
    params.require(:organisation).permit(:name)
  end

end
