class Organisation::OrganisationNumbersController < ApplicationController
  include Wicked::Wizard

  steps :numbers

  before_action :authenticate_user!\

  def show

    @organisation = Organisation.find(params[:organisation_id])

    render_wizard

  end

  def update

    company_number = params[:organisation][:company_number].present? ? params[:organisation][:company_number] : nil
    charity_number = params[:organisation][:charity_number].present? ? params[:organisation][:company_number] : nil

    @organisation = Organisation.find(params[:organisation_id])

    logger.debug 'Updating organisation ' + @organisation.id +
                     ', setting company_number to ' + company_number.to_s +
                     ' and setting charity_number to ' + charity_number.to_s

    @organisation = Organisation.update(params[:organisation_id],
                                        :company_number => company_number,
                                        :charity_number => charity_number)

    logger.debug 'Finished updating organisation ' + @organisation.id

    redirect_to_finish_wizard

  end

  def finish_wizard_path

    organisation_organisation_about_get_path(params[:organisation_id]) + '?id=about'

  end
end
