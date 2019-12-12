class Organisation::OrganisationMissionController < ApplicationController
  include Wicked::Wizard

  steps :mission

  before_action :authenticate_user!

  def show

    @organisation = Organisation.find(params[:organisation_id])

    render_wizard

  end

  def update

    @organisation = Organisation.find(params[:organisation_id])

    logger.debug 'Updating organisation ' + @organisation.id +
                     ', setting mission to ' + params[:organisation][:mission]

    @organisation = Organisation.update(params[:organisation_id],
                                        :mission => params[:organisation][:mission])

    logger.debug 'Finished updating organisation ' + @organisation.id

    redirect_to_finish_wizard

  end

  def finish_wizard_path

    organisation_organisation_signatories_get_path(params[:organisation_id]) + '?id=signatories'

  end

end
