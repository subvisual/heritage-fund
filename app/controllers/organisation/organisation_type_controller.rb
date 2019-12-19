class Organisation::OrganisationTypeController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show
    render :type
  end

  def update

    logger.debug "Attempting to update organisation ID: #{@organisation.id} "

    @organisation.validate_org_type = true

    @organisation.update(organisation_type_params)

    if @organisation.valid?

      redirect_to :organisation_organisation_numbers_get

    else

      logger.debug "Organisation type not found when attempting to update organisation ID: " +
                       "#{@organisation.id}"

      flash[:alert] = @organisation.errors[:org_type][0]

      redirect_to :organisation_organisation_type_get

    end

    logger.debug "Finished updating organisation ID: #{@organisation.id}"

  end

  private

  def organisation_type_params

    if !params[:organisation].present?
      params.merge!({organisation: {org_type: ""}})
    end

    params.require(:organisation).permit(:org_type)

  end

end
