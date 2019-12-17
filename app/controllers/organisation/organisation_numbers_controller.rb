class Organisation::OrganisationNumbersController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show
    render :numbers
  end

  def update

    company_number = params[:organisation][:company_number].present? ? params[:organisation][:company_number] : nil
    charity_number = params[:organisation][:charity_number].present? ? params[:organisation][:charity_number] : nil

    logger.debug "Updating organisation #{@organisation.id}, " +
                     "setting company_number to #{company_number.to_s} " +
                     "and setting charity_number to #{charity_number.to_s}"

    @organisation.update(company_number: company_number, charity_number: charity_number)

    logger.debug "Finished updating organisation #{@organisation.id}"

    redirect_to :organisation_organisation_about_get


  end

  private

end
