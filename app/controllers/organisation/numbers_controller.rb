class Organisation::NumbersController < ApplicationController
  include OrganisationContext, ObjectErrorsLogger

  # This method updates the company_number and/or charity_number attributes
  # of an organisation redirecting to :organisation_about if successful and
  # re-rendering the :show method if unsuccessful
  def update

    logger.info "Updating company_number/charity_number for organisation ID: #{@organisation.id}"

    # Neither field on this page is mandatory, so we only want to validate them
    # if they are passed through the form
    @organisation.validate_company_number = true if params[:organisation].key("company_number")
    @organisation.validate_charity_number = true if params[:organisation].key("charity_number")

    @organisation.update(organisation_params)

    if @organisation.valid?

      logger.info "Finished updating company_number/charity_number for organisation ID: #{@organisation.id}"

      redirect_to :organisation_about

    else

      logger.info "Validation failed when attempting to update company_number/charity_number " \
                    "for organisation ID: #{@organisation.id}"

      log_errors(@organisation)

      render :show

    end

  end

  private
  def organisation_params
    params.require(:organisation).permit(:company_number, :charity_number)
  end

end
