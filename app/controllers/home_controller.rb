class HomeController < ApplicationController

  before_action :authenticate_user!

  # Renders the 'Apply for a grant' homepage, only if a user has logged in
  # Before rendering the page, an empty organisation is created and linked back
  # to the user
  def show

    # TODO: Check that the user doesn't already have an organisation associated to
    #       them before creating a new one

    logger.debug 'Creating organisation for user ID: ' + current_user.id.to_s

    @organisation = Organisation.create

    logger.debug 'Finished creating organisation ' + @organisation.id +
                     ' for user ID: ' + current_user.id.to_s

    logger.debug 'Updating user ID: ' + current_user.id.to_s +
                     ' with link to organisation ' + @organisation.id

    @user = User.update(current_user.id, organisation_id: @organisation.id)

    logger.debug 'Finished updating user ID: ' + current_user.id.to_s +
                     ' with link to organisation ' + @organisation.id

  end

end
