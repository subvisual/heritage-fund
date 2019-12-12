class Organisation::OrganisationAboutController < ApplicationController
  include Wicked::Wizard

  steps :about

  before_action :authenticate_user!

  def show

    @organisation = Organisation.find(current_user.organisation.id)

    render_wizard

  end

  def update

    @organisation = Organisation.find(current_user.organisation.id)

    logger.debug 'Updating organisation ' + @organisation.id +
                     ', setting name to ' + params[:organisation][:name] +
                     ', postcode to ' + params[:organisation][:postcode] +
                     ' and line1 to ' + params[:organisation][:line1]

    @organisation = Organisation.update(current_user.organisation.id,
                                        :name => params[:organisation][:name],
                                        :postcode => params[:organisation][:postcode],
                                        :line1 => params[:organisation][:line1]
    )

    logger.debug 'Finished updating organisation ' + @organisation.id

    redirect_to_finish_wizard

  end

  def finish_wizard_path

    organisation_organisation_mission_get_path(current_user.organisation.id, id:'mission')

  end
end
