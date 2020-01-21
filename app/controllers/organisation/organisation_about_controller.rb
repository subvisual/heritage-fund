require 'ideal_postcodes'

class Organisation::OrganisationAboutController < ApplicationController
  include OrganisationHelper
  before_action :set_api_key, :authenticate_user!, :set_organisation

  # Renders the initial postcode lookup view
  def show_postcode_lookup
    render :postcode_lookup
  end

  # Renders the full organisation name and address view
  def show
    render :about
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

      logger.error "No postcode entered when searching for an address for organisation ID: #{@organisation.id}"

      redirect_to(:organisation_about_get, flash: {
          errors: {
              postcode: 'Please enter a postcode'
          }
        }
      )

    else

      lookup_postcode

      if @response.empty?

        logger.debug "No results found when searching for postcode #{params['postcode']['lookup']} " +
                         " for organisation ID: #{@organisation.id}"

        redirect_to(:organisation_about_get, flash: {
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

  # Assigns address-related attributes to the organisation model object
  # based on the response from an IdealPostcodes API lookup.
  # Attributes are assigned here in order to populate the input fields
  # on the :about view.
  def assign_address_attributes

    # TODO: Cache the initial address response from the IdealPostcodes API
    #       and use this if available, rather than looking up the address again
    lookup_address

    @organisation.assign_attributes({
      line1: @address_response.fetch(:line_1),
      line2: @address_response.fetch(:line_2),
      line3: @address_response.fetch(:line_3),
      postcode: @address_response.fetch(:postcode),
      townCity: @address_response.fetch(:post_town),
      county: @address_response.fetch(:county)
    })

    render :about

  end

  def update

    @organisation.validate_address = true

    @organisation.update(organisation_about_params)

    if @organisation.valid?

      redirect_to :organisation_organisation_mission_get

    else

      logger.error "Organisation address invalid when attempting to update organisation ID: " +
                       "#{@organisation.id}"

      render :about

    end

  end

  private

  def set_api_key
    IdealPostcodes.api_key = Rails.configuration.x.ideal_postcodes.api_key
  end

  def organisation_about_params
    params.require(:organisation).permit(:name, :line1, :line2, :line3, :townCity, :county, :postcode)
  end

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

end
