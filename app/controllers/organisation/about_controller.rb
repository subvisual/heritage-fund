class Organisation::AboutController < ApplicationController
  include OrganisationContext, PostcodeLookup

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

  def update

    @organisation.validate_address = true

    @organisation.update(organisation_about_params)

    if @organisation.valid?

      redirect_to :organisation_mission

    else

      logger.error "Organisation address invalid when attempting to update organisation ID: " +
                       "#{@organisation.id}"

      render :about

    end

  end

  private
  def organisation_about_params
    params.require(:organisation).permit(:name, :line1, :line2, :line3, :townCity, :county, :postcode)
  end

end
