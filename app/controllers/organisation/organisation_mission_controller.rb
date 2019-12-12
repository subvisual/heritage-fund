class Organisation::OrganisationMissionController < ApplicationController
  include Wicked::Wizard

  steps :mission

  before_action :authenticate_user!

  def show

    @organisation = Organisation.find(current_user.organisation.id)

    render_wizard

  end

  def update

    @organisation = Organisation.find(current_user.organisation.id)

    logger.debug 'Updating organisation ' + @organisation.id +
                     ', setting mission to ' + params[:organisation][:mission]

    @organisation = Organisation.update(current_user.organisation.id,
                                        :mission => params[:organisation][:mission])

    logger.debug 'Finished updating organisation ' + @organisation.id

    redirect_to_finish_wizard

  end

  def finish_wizard_path

    organisation_organisation_signatories_get_path(current_user.organisation.id, id: 'signatories')

  end

end
