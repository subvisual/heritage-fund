module OrganisationHelper

  # Helper method to set the organisation instance variable equal
  # to the organisation of the current user
  def set_organisation
    if !@organisation.present?
      @organisation = Organisation.find(current_user.organisation.id)
    end
  end

end
