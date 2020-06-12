class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show

    unless user_details_complete(current_user)
      redirect_to user_details_path
    else
      gon.push({tracking_url_path: '/project-dashboard'})
      @projects = current_user.projects
    end

  end

  # Early users of the service may not have an organisation linked to their
  # user account. Because of this, we need to check for an organisation and
  # create one if none is present. We also check for the mandatory 
  # organisation details to be complete before we can allow a user to 
  # create a new application.
  def orchestrate_dashboard_journey

    create_organisation_if_none_exists(current_user)

    redirect_based_on_organisation_completeness(current_user.organisation)

  end

  private

  # Checks for the presence of mandatory fields on a given user.
  # Returns true if all mandatory fields are present, otherwise
  # returns false.
  #
  # @param [User] user An instance of User
  def user_details_complete(user)

    user_details_fields_presence = []

    user_details_fields_presence.push(user.name.present?)
    user_details_fields_presence.push(user.date_of_birth.present?)
    user_details_fields_presence.push(
        (
        user.line1.present? &&
            user.townCity.present? &&
            user.county.present? &&
            user.postcode.present?
        )
    )

    return user_details_fields_presence.all?

  end

  # Checks for the presence of an organisation associated to a user 
  # and creates one if none exists
  #
  # @param [User] user An instance of User
  def create_organisation_if_none_exists(user)

    unless user.organisation

      logger.info "No organisation found for user ID: #{user.id}"

      create_organisation(user)

    end

  end
  
  # Creates an organisation and links this to the current_user
  #
  # @param [User] user An instance of User
  def create_organisation(user)

    organisation = Organisation.new

    logger.info "Successfully created organisation ID: #{organisation.id}"

    user.organisation = organisation

    logger.info "Setting organisation_id of '#{organisation.id}' for user ID: #{user.id}"

    user.save

  end

  # Redirects the user based on the completeness of their associated organisation
  # If complete, we redirect to new_application_path, otherwise if an organisation
  # is missing mandatory details, we redirect to the first page of the organisation
  # section of the service
  #
  # @param [Organisation] organisation An instance of Organisation
  def redirect_based_on_organisation_completeness(organisation)

    if helpers.complete_organisation_details?(organisation)

      logger.info "Organisation details complete for #{organisation.id}"

      redirect_to start_an_application_path

    else

      logger.info "Organisation details not complete for #{organisation.id}"

      redirect_to organisation_type_path(organisation.id)

    end

  end

end
