class Organisation::OrganisationMissionController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show
    render :mission
  end

  def update
    # This information about an organisation doesn't have to be provided,
    # therefore we only want to update the model if the user has selected
    # a form option. We can tell whether this has been done by checking
    # for the presence of an organisation hash.
    if !params[:organisation].nil?
      #logger.debug 'Updating organisation ' + @organisation.id +
      #                 ', setting mission to ' + params[:organisation][:mission]

      @organisation.update(mission: params[:organisation][:mission])

      logger.debug "Finished updating organisation #{@organisation.id}"
    else
      logger.debug "No mission added for organisation #{@organisation.id}"
    end

    redirect_to :organisation_organisation_signatories_get

  end

  private

  def organisation_mission_params
    params.require(:organisation).permit(:mission)
  end


end
