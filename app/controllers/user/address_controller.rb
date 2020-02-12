class User::AddressController < ApplicationController
  include PostcodeLookup
  before_action :authenticate_user!

  # Renders the initial postcode lookup view
  def show_postcode_lookup
    render :postcode_lookup
  end

  def update

    logger.debug "Updating address details for user ID: #{current_user.id}"

    current_user.validate_address = true

    current_user.update(user_params)

    if current_user.valid?

      logger.debug "Finishing updating address details for user ID: #{current_user.id}"

      redirect_to :authenticated_root

    else

      logger.debug "Validation failed when updating address details for user ID: #{current_user.id}"

      render :show

    end

  end


  def assign_address_attributes

    assign_attributes(current_user)

    render :show

  end


  private
  def user_params
    params.require(:user).permit(:line1, :line2, :line3, :townCity, :county, :postcode)
  end

end
