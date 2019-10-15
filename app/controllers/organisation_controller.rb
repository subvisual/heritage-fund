class OrganisationController < ApplicationController
    include Secured

    def index
    end


def new
    @organisation = Organisation.new
end

def create
  @organisation = Organisation.create!(organisation_params)
  @user = User.find_by(uid: session[:user_id])
  @user.organisation = @organisation
  @user.save
  redirect_to '/projects/new'
end

private
  def organisation_params
    params.require(:organisation).permit(:name)
  end

end
