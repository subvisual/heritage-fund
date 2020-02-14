class Organisation::AboutController < ApplicationController
  include OrganisationContext, ObjectErrorsLogger, PostcodeLookup

  # Renders the initial postcode lookup view
  def show_postcode_lookup
    render :postcode_lookup
  end

  # Renders the full organisation name and address view
  def show
    render :about
  end


  def assign_address_attributes

    assign_attributes(@organisation)

    render :about

  end

  # This method updates the mission attribute of an organisation,
  # redirecting to :organisation_mission if successful and re-rendering
  # :about method if unsuccessful
  def update

    logger.info "Updating address for organisation ID: #{@organisation.id}"

    @organisation.validate_address = true

    @organisation.update(organisation_about_params)

    if @organisation.valid?

      logger.info "Finished updating address for organisation ID: " \
                  "#{@organisation.id}"

      redirect_to :organisation_mission

    else

      logger.info "Validation failed when attempting to update address for " \
                  "organisation ID: #{@organisation.id}"

      log_errors(@organisation)

      render :about

    end

  end

  private
  def organisation_about_params
    params.require(:organisation)
        .permit(:name, :line1, :line2, :line3,
                :townCity, :county, :postcode)
  end

end
