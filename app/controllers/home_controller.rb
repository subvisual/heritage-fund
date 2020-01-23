class HomeController < ApplicationController

  before_action :authenticate_user!

  # Renders the 'Apply for a grant' homepage, only if a user has logged in
  # Before rendering the page, we check whether the user belongs to an
  # organisation and create a new Organisation instance if not. This is
  # then used to provide the organisation UUID in the URL.
  def show

    if current_user.organisation

      logger.info "Existing organisation #{current_user.organisation.id} found for #{current_user.id}"

      @start_now_link_value = complete_organisation_details? ? three_to_ten_k_project_create_path :
                                  organisation_type_path(current_user.organisation.id)

    else

      logger.info "No existing organisation found for user ID: #{current_user.id}"

      logger.debug "Creating organisation for user ID: #{current_user.id}"

      @organisation = Organisation.create

      logger.debug "Finished creating organisation #{@organisation.id} for user ID: #{current_user.id}"

      logger.debug "Updating user ID: #{current_user.id} with link to organisation #{@organisation.id}"

      @user = User.update(current_user.id, organisation_id: @organisation.id)

      logger.debug "Finished updating user ID: #{current_user.id.to_s}  with link to organisation #{@organisation.id}"

      @start_now_link_value = organisation_type_path(@organisation.id)

    end

  end

  private
  # Checks for the presence of mandatory organisation parameters,
  # returning false if any are not present and true if all are
  # present
  def complete_organisation_details?

    return [
        current_user.organisation.name.present?,
        current_user.organisation.line1.present?,
        current_user.organisation.townCity.present?,
        current_user.organisation.county.present?,
        current_user.organisation.postcode.present?,
        current_user.organisation.org_type.present?,
        current_user.organisation.legal_signatories.exists?
    ].all?

  end

end
