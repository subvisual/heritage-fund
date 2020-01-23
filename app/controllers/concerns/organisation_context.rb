module OrganisationContext
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!, :set_organisation
  end

  # This method retrieves an organisation object based on the id
  # found in the URL parameters and the current authenticated
  # user's id, setting it as an instance variable for use in
  # organisation-related controllers.
  #
  # If the user's organisation id and the organisation id param
  # do not match, then the user is redirected to the projects
  # dashboard
  #
  # TODO: Write tests for this.
  def set_organisation

    unless params[:organisation_id] == current_user.organisation&.id
      redirect_to :authenticated_root
    else
      @organisation = Organisation.find_by(id: current_user.organisation&.id)
    end

  end

end