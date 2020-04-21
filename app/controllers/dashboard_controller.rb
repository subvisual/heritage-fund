class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show

    unless user_details_complete
      redirect_to user_details_path
    else
      gon.push({tracking_url_path: '/project-dashboard'})
      @projects = current_user.projects
    end

  end

  private
  def user_details_complete

    user_details_fields_presence = []

    user_details_fields_presence.push(current_user.name.present?)
    user_details_fields_presence.push(current_user.date_of_birth.present?)
    user_details_fields_presence.push(
        (
        current_user.line1.present? &&
            current_user.townCity.present? &&
            current_user.county.present? &&
            current_user.postcode.present?
        )
    )

    return user_details_fields_presence.all?

  end
  
end
