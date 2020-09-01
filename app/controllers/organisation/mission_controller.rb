# Controller for a page that asks about the mission, or objectives, of an organisation.
class Organisation::MissionController < ApplicationController
  include OrganisationContext
  include ObjectErrorsLogger

  # This method updates the mission attribute of an organisation,
  # redirecting to :organisation_signatories if successful and re-rendering
  # :show method if unsuccessful
  def update

    logger.info "Updating mission for organisation ID: #{@organisation.id}"

    @organisation.validate_mission = true

    @organisation.update(organisation_params)

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

  def organisation_params

    # When no checkbox is selected on the page no mission key/value is passed
    # in the form, meaning that the organisation hash is no longer passed
    # through either. In this case, we need to add it manually to avoid
    # triggering a 'param is missing or value is empty' exception

    params.merge!({ organisation: { mission: '' } }) unless params[:organisation].present?

    params.require(:organisation).permit(:mission, mission: [])

  end

end
