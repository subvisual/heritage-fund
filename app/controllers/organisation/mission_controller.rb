class Organisation::MissionController < ApplicationController
  include OrganisationContext

  def update

    logger.debug "Attempting to update organisation ID: #{@organisation.id} "

    @organisation.validate_mission = true

    @organisation.update(organisation_mission_params)

    if @organisation.valid?

      redirect_to :organisation_signatories

    else

      logger.debug "Organisation type invalid when attempting to update organisation ID: " +
                       "#{@organisation.id}"

      render :show

    end

    logger.debug "Finished updating organisation ID: #{@organisation.id}"

  end

  private

  def organisation_mission_params

    if !params[:organisation].present?
      params.merge!({organisation: {mission: ""}})
    end

    params.require(:organisation).permit(mission: [])

  end


end
