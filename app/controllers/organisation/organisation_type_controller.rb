class Organisation::OrganisationTypeController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  @@error_message = "Select the type of organisation that will be running your project"

  def show
    render :type
  end

  def update
    @organisation.validate_org_type

    if !params[:organisation].present?

      logger.debug "Organisation type not found when attempting to update organisation ID: " +
                       "#{@organisation.id}"

      flash[:alert] = @@error_message

    else

      logger.debug "Attempting to updating organisation ID: #{@organisation.id} " +
                       "- setting org_type to #{params[:organisation][:org_type]}"

      if !@organisation.update(organisation_type_params)

        logger.debug "Error occurred when updating organisation ID: #{@organisation.id}"

        flash[:alert] = @@error_message

      else

        logger.debug "Finished updating organisation ID: #{@organisation.id}"

      end

    end

    redirect_to flash[:alert].present? ? :organisation_organisation_type_get : :organisation_organisation_numbers_get

  end

  private

  def organisation_type_params
    params.require(:organisation).permit(:org_type)
  end

end
