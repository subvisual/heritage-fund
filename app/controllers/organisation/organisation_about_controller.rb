class Organisation::OrganisationAboutController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show
    render :about
  end

  def update

    logger.debug "Updating organisation #{@organisation.id} " +
                     "setting name to #{params[:organisation][:name]}, " +
                     "postcode to #{params[:organisation][:postcode]} " +
                     "and line1 to #{params[:organisation][:line1]}"

    @organisation.update(organisation_about_params)

    logger.debug "Finished updating organisation #{@organisation.id}"

    redirect_to :organisation_organisation_mission_get

  end

  private

  def organisation_about_params
    params.require(:organisation).permit(:name, :postcode, :line1)
  end

end
