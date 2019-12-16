class Organisation::OrganisationTypeController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show
    render :type
  end

  def update

    logger.debug "Updating organisation ID: #{@organisation.id} setting org_type to #{params[:organisation][:org_type]}"

    @organisation.update(organisation_type_params)

    logger.debug "Finished updating organisation ID: #{@organisation.id}"

    redirect_to :organisation_organisation_numbers_get

  end

  private

  def organisation_type_params
    params.require(:organisation).permit(:org_type)
  end

end
