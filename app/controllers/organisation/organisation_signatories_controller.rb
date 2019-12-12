class Organisation::OrganisationSignatoriesController < ApplicationController
  include Wicked::Wizard

  steps :signatories

  before_action :authenticate_user!

  def show

    logger.info 'IN THIS SHOW METHOD'

    @organisation = Organisation.find(params[:organisation_id])

    render_wizard

  end

  def update

    @organisation = Organisation.find(params[:organisation_id])

    #logger.debug 'Updating organisation ' + @organisation.id +
    #                 ', setting mission to ' + params[:organisation][:mission]

    #@organisation = Organisation.update(params[:organisation_id],
    #                                    :mission => params[:organisation][:mission])

    logger.debug 'Finished updating organisation ' + @organisation.id

    redirect_to_finish_wizard

  end


  def finish_wizard_path

    organisation_organisation_summary_get_path(params[:organisation_id])

  end

end
