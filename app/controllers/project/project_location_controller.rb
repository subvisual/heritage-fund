require 'ideal_postcodes'

class Project::ProjectLocationController < ApplicationController
  include ProjectContext, PostcodeLookup

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


  def assign_address_attributes
    assign_attributes(@project)

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

end
