class Organisation::MissionController < ApplicationController
  include OrganisationContext, ObjectErrorsLogger

  # This method updates the mission attribute of an organisation,
  # redirecting to :organisation_signatories if successful and re-rendering
  # :show method if unsuccessful
  def update

    logger.info "Updating mission for organisation ID: #{@organisation.id}"

    @organisation.validate_mission = true

    @organisation.update(organisation_mission_params)

    if @organisation.valid?

      logger.info "Finished updating mission for organisation ID: #{@organisation.id}"

      redirect_to :organisation_signatories

    else

      logger.info "Validation failed when attempting to update mission for organisation ID: #{@organisation.id}"

      log_errors(@organisation)

      render :show

    end

  end

  private
  def organisation_mission_params

    # When no checkbox is selected on the page no mission key/value is passed in the form,
    # meaning that the organisation hash is no longer passed through either. In this case, we
    # need to add it manually to avoid triggering a 'param is missing or value is empty'
    # exception
    if !params[:organisation].present?
      params.merge!({organisation: {mission: ""}})
    end

    params.require(:organisation).permit(mission: [])

  end


end
