require 'ideal_postcodes'

module PostcodeLookup
  extend ActiveSupport::Concern
  included do
    before_action :set_api_key
  end

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

  # Assigns address-related attributes to the record param object
  # based on the response from an IdealPostcodes API lookup.
  # Attributes are assigned here in order to populate the input fields
  # on the following view.
  # TODO: Cache the initial address response from the IdealPostcodes API
  #       and use this if available, rather than looking up the address again
  def assign_attributes(record)

    lookup_address
    record.assign_attributes({
                                 line1: @address_response.fetch(:line_1),
                                 line2: @address_response.fetch(:line_2),
                                 line3: @address_response.fetch(:line_3),
                                 postcode: @address_response.fetch(:postcode),
                                 townCity: @address_response.fetch(:post_town),
                                 county: @address_response.fetch(:county)
                             })

  end

  # Makes a request to the IdealPostcodes API to retrieve a list of addresses
  # matching the given postcode.
  # If no postcode or an invalid postcode is found, this method redirects the user
  # back to the current view.
    def display_address_search_results

    # TODO: Add postcode validation to return a helpful error message to
    #       the user, rather than relying on the empty array returned from
    #       the IdealPostcodes API to determine the 'No results found' message
    unless params['postcode']['lookup'].present?

      logger.error "No postcode entered when searching for an address"

      redirect_to(request.path, flash: {
          errors: {
              postcode: 'Please enter a postcode'
          }
      }
      )

    else

      lookup_postcode

      if @response.empty?

        logger.debug "No results found when searching for postcode #{params['postcode']['lookup']}"

        redirect_to(request.path, flash: {
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

  private

  def set_api_key
    IdealPostcodes.api_key = Rails.configuration.x.ideal_postcodes.api_key
  end

end