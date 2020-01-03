require 'ideal_postcodes'
require 'pry'

class Project::ProjectLocationController < ApplicationController
  include ProjectContext
  before_action :set_api_key

  # This method is used to update the project address when the project address
  # is not located at the same place as the organisation address
  def different_location

    logger.debug "Updating address for project ID: #{@project.id}"

    @project.validate_address = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Finished updating address for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_description_get_path(@project.id)

    else

      logger.error "Project address invalid when attempting to update project ID: #{@project.id}"

      render :entry

    end

  end

  # Renders the initial postcode lookup view
  # TODO: Refactor this into a single place for both
  #       organisation and projects
  def show_postcode_lookup
    render :postcode_lookup
  end

  def other_location
  end

  # Makes a request to the IdealPostcodes API to retrieve a list of addresses
  # matching the given postcode.
  # If no postcode or an invalid postcode is found, this method redirects the user
  # back to the :postcode_lookup view.
  # TODO: Refactor this into a single place for both
  #       organisation and projects
  def display_address_search_results

    # TODO: Add postcode validation to return a helpful error message to
    #       the user, rather than relying on the empty array returned from
    #       the IdealPostcodes API to determine the 'No results found' message
    unless params['postcode']['lookup'].present?

      logger.error "No postcode entered when searching for an address for project ID: #{@project.id}"

      redirect_to(:three_to_ten_k_project_location_postcode_get, flash: {
          errors: {
              postcode: 'Please enter a postcode'
          }
        }
      )

    else

      lookup_postcode

      if @response.empty?

        logger.debug "No results found when searching for postcode #{params['postcode']['lookup']} " +
                         " for project ID: #{@project.id}"

        redirect_to(:three_to_ten_k_project_location_postcode_get, flash: {
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

  # Assigns address-related attributes to the project model object
  # based on the response from an IdealPostcodes API lookup.
  # Attributes are assigned here in order to populate the input fields
  # on the :address view.
  # TODO: Refactor this into a single place for both
  #       organisation and projects
  def assign_address_attributes

    # TODO: Cache the initial address response from the IdealPostcodes API
    #       and use this if available, rather than looking up the address again
    lookup_address

    @project.assign_attributes({
                                        line1: @address_response.fetch(:line_1),
                                        line2: @address_response.fetch(:line_2),
                                        line3: @address_response.fetch(:line_3),
                                        postcode: @address_response.fetch(:postcode),
                                        townCity: @address_response.fetch(:post_town),
                                        county: @address_response.fetch(:county)
                                    })

    render :entry

  end

  def update

    @project.validate_same_location = true

    @project.update(project_params)

    if @project.valid?

      if @project.same_location == "yes"

        logger.debug "Same location as organisation selected for project ID: #{@project.id}"

        add_project_address_fields

        @project.save

        logger.debug "Finished updating location for project ID: #{@project.id}"

        redirect_to three_to_ten_k_project_description_get_path(@project.id)

      else

        logger.debug "Different location to organisation selected for project ID: #{@project.id}"

        redirect_to three_to_ten_k_project_location_postcode_get_path(@project.id)

      end

    else

      render :project_location

    end

  end

  private

  def project_params

    unless params[:project].present?
      params.merge!({project: {same_location: ""}})
    end

    params.require(:project).permit(:same_location, :line1, :line2, :line3, :townCity, :county, :postcode)
  end

  # Replicates address data from the organisation model linked to the current user
  # into the project model address fields
  def add_project_address_fields

    logger.debug "Setting project address fields for project ID: #{@project.id}"

    @organisation = Organisation.find(current_user.organisation.id)

    @project.line1 = @organisation.line1
    @project.line2 = @organisation.line2
    @project.line3 = @organisation.line3
    @project.townCity = @organisation.townCity
    @project.county = @organisation.county
    @project.postcode = @organisation.postcode

    logger.debug "Finished setting project address fields for project ID: #{@project.id}"

  end

  # TODO: Refactor this into a single place for both
  #       organisation and projects
  def set_api_key
    IdealPostcodes.api_key = Rails.configuration.x.ideal_postcodes.api_key
  end

  # TODO: Refactor this into a single place for both
  #       organisation and projects
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
  # TODO: Refactor this into a single place for both
  #       organisation and projects
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
