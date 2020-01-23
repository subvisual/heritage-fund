require 'ideal_postcodes'

class User::AddressController < ApplicationController
  before_action :authenticate_user!, :set_api_key

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

  # Makes a request to the IdealPostcodes API to retrieve a list of addresses
  # matching the given postcode.
  # If no postcode or an invalid postcode is found, this method redirects the user
  # back to the :postcode_lookup view.
  def display_address_search_results

    # TODO: Add postcode validation to return a helpful error message to
    #       the user, rather than relying on the empty array returned from
    #       the IdealPostcodes API to determine the 'No results found' message
    unless params['postcode']['lookup'].present?

      logger.error "No postcode entered when searching for an address for user ID: #{current_user.id}"

      redirect_to(:user_address, flash: {
          errors: {
              postcode: 'Please enter a postcode'
          }
      }
      )

    else

      lookup_postcode

      if @response.empty?

        logger.debug "No results found when searching for postcode #{params['postcode']['lookup']} " +
                         " for organisation ID: #{current_user.id}"

        redirect_to(:user_address, flash: {
            errors: {
                postcode: 'No results found for postcode'
            }
        }
        )

      else

        respond_to do |format|
          format.html {
            render :address_results
          }
        end

      end

    end

  end

  # Assigns address-related attributes to the current user model object
  # based on the response from an IdealPostcodes API lookup.
  # Attributes are assigned here in order to populate the input fields
  # on the :about view.
  def assign_address_attributes

    # TODO: Cache the initial address response from the IdealPostcodes API
    #       and use this if available, rather than looking up the address again
    lookup_address

    current_user.assign_attributes({
                                        line1: @address_response.fetch(:line_1),
                                        line2: @address_response.fetch(:line_2),
                                        line3: @address_response.fetch(:line_3),
                                        postcode: @address_response.fetch(:postcode),
                                        townCity: @address_response.fetch(:post_town),
                                        county: @address_response.fetch(:county)
                                    })

    render :show

  end

  private
  def set_api_key
    IdealPostcodes.api_key = Rails.configuration.x.ideal_postcodes.api_key
  end

  private
  def lookup_postcode

    # TODO: Add error handling around API exceptions

    begin
      @response = IdealPostcodes::Postcode.lookup params['postcode']['lookup']
    rescue IdealPostcodes::AuthenticationError => e
      # Invalid API Key
    rescue IdealPostcodes::TokenExhaustedError => e
      # Token has run out of lookups
    rescue IdealPostcodes::LimitReachedError => e
      # One of your predefinied limits has been reached
    rescue IdealPostcodes::IdealPostcodesError => e
      # API Error
    rescue => e
      # An unexpected error
    end

  end

  # Takes a given address in the params hash and looks this up within
  # the IdealPostcodes API
  private
  def lookup_address

    # TODO: Add error handling around API exceptions

    begin
      @address_response = IdealPostcodes::Address.lookup params[:address]
    rescue IdealPostcodes::AuthenticationError => e
      # Invalid API Key
    rescue IdealPostcodes::TokenExhaustedError => e
      # Token has run out of lookups
    rescue IdealPostcodes::LimitReachedError => e
      # One of your predefinied limits has been reached
    rescue IdealPostcodes::IdealPostcodesError => e
      # API Error
    rescue => e
      # An unexpected error
    end

  end

  private
  def user_params
    params.require(:user).permit(:line1, :line2, :line3, :townCity, :county, :postcode)
  end

end
