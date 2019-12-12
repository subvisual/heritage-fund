class Organisation::OrganisationTypeController < ApplicationController
  include Wicked::Wizard

  steps :type

  before_action :authenticate_user!

  def show

    @organisation = Organisation.find(current_user.organisation.id)

    render_wizard

  end

  def update

    @organisation = Organisation.find(current_user.organisation.id)

    logger.debug 'Updating organisation ' + @organisation.id +
                     ', setting org_type to ' + params[:organisation][:org_type]

    @organisation = Organisation.update(params[:organisation_id],
                                        :org_type => params[:organisation][:org_type])

    logger.debug 'Finished updating organisation ' + @organisation.id

    redirect_to_finish_wizard

  end

  def finish_wizard_path

    organisation_organisation_numbers_get_path(params[:organisation_id]) + '?id=numbers'

  end

end
