# Controller for a page that asks for details on the type of organisation applying.
class Organisation::TypesController < ApplicationController
  include OrganisationContext
  include ObjectErrorsLogger

  # This method updates the org_type attribute of an organisation,
  # redirecting to :organisation_numbers if successful and re-rendering
  # :show method if unsuccessful
  def update
    logger.info "Updating org_type for organisation ID: #{@organisation.id}"

    @organisation.validate_org_type = true

    @organisation.update(organisation_params)

    if @organisation.valid?

      logger.info "Finished updating org_type for organisation ID: #{@organisation.id}"

      redirect_to :organisation_numbers

    else

      logger.info "Validation failed when attempting to update org_type for organisation ID: #{@organisation.id}"

      log_errors(@organisation)

      render :show

    end
  end

  private

  def organisation_params
    # When no radio button is selected on the page no org_type key/value is passed in the form,
    # meaning that the organisation hash is no longer passed through either. In this case, we
    # need to add it manually to avoid triggering a 'param is missing or value is empty'
    # exception
    params[:organisation] = { org_type: '' } unless params[:organisation].present?

    params.require(:organisation).permit(:org_type)
  end
end
