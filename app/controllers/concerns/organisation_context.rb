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
  # If no organisation object matching the parameters is found,
  # then the user is redirected to the projects dashboard.
  #
  # TODO: Write tests for this.
  def set_organisation

    authorised = false

    if params[:organisation_id] == current_user.organisation&.id
      @organisation = Organisation.find_by(id: params[:organisation_id])
      authorised = @organisation.present?
    end

    redirect_to :authenticated_root if authorised == false

  end

end