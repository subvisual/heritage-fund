class User::DetailsController < ApplicationController
  before_action :authenticate_user!

  def update

    logger.debug "Updating user details for user ID: #{current_user.id}"

    current_user.validate_details = true

    current_user.update(user_params)

    if current_user.valid?

      current_user.date_of_birth = Date.new(
          params[:user][:dob_year].to_i,
          params[:user][:dob_month].to_i,
          params[:user][:dob_day].to_i
      )

      current_user.save

      logger.debug "Finished updating user details for user ID: #{current_user.id}"

      redirect_to user_address_path

    else

      logger.debug "Validation failed when updating user details for user ID: #{current_user.id}"

      store_values_in_flash

      render :show

      # Clear the flash to ensure that we do not show flashed values upon revisiting the page
      flash.discard

    end

  end

  private

  # Temporarily stores values in FlashHash to redisplay if there
  # have been any errors - this is necessary as we don't have
  # model attributes that are persistent for the individual date
  # items.
  def store_values_in_flash

    params[:user].each do | key, value |
      flash[key] = value.empty? ? "" : value
    end

  end

  def user_params
    params.require(:user).permit(:name, :dob_day, :dob_month, :dob_year, :phone_number)
  end

end