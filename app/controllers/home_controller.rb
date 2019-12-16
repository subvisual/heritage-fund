class HomeController < ApplicationController

  before_action :authenticate_user!

  # Renders the 'Apply for a grant' homepage, only if a user has logged in
  # Before rendering the page, we check whether the user belongs to an
  # organisation and create a new Organisation instance if not. This is
  # then used to provide the organisation UUID in the URL.
  def show

    if current_user.organisation

      logger.info 'Existing organisation ' + current_user.organisation.id +
                      ' found for ' + current_user.id.to_s
      @start_now_link_value = organisation_organisation_summary_get_path(current_user.organisation.id)

    else

      logger.info 'No existing organisation found for user ID: ' + current_user.id.to_s

      logger.debug 'Creating organisation for user ID: ' + current_user.id.to_s

      @organisation = Organisation.create

      logger.debug 'Finished creating organisation ' + @organisation.id +
                       ' for user ID: ' + current_user.id.to_s

      logger.debug 'Updating user ID: ' + current_user.id.to_s +
                       ' with link to organisation ' + @organisation.id

      @user = User.update(current_user.id, organisation_id: @organisation.id)

      logger.debug 'Finished updating user ID: ' + current_user.id.to_s +
                       ' with link to organisation ' + @organisation.id

      @start_now_link_value = organisation_organisation_type_get_path(@organisation.id)

    end

  end

end
