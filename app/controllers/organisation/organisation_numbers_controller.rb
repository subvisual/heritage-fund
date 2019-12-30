class Organisation::OrganisationNumbersController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show
    render :numbers
  end

  def update

    company_number = params[:organisation][:company_number].present? ? params[:organisation][:company_number] : nil
    charity_number = params[:organisation][:charity_number].present? ? params[:organisation][:charity_number] : nil

    logger.debug "Attempting to update organisation ID: #{@organisation.id}, " +
                     "setting company_number and charity_number"

    @organisation.validate_company_number = true
    @organisation.validate_charity_number = true

    @organisation.update(company_number: company_number, charity_number: charity_number)

    if @organisation.valid?

      logger.debug "Finished setting company_number and charity_number for " +
                       "organisation ID: #{@organisation.id}"

      redirect_to :organisation_about_get

    else

      logger.debug "Invalid company or charity number found when attempting " +
                       "to update organisation ID: #{@organisation.id}"

      render :numbers

    end

  end

  private

end
