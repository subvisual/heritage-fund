# Controller for a page that asks for details of legal signatories.
class Organisation::SignatoriesController < ApplicationController
  include OrganisationContext
  include ObjectErrorsLogger

  def show
    @organisation.legal_signatories.build unless
        @organisation.legal_signatories.first.present?
    @organisation.legal_signatories.build unless
        @organisation.legal_signatories.second.present?
  end

  def update
    logger.info "Updating legal signatories for organisation ID: #{@organisation.id}"

    @organisation.validate_legal_signatories = true

    @organisation.update(organisation_params)

    if @organisation.valid?

      logger.info "Finished updating legal signatories for organisation ID: #{@organisation.id}"

      redirect_to :organisation_summary

    else

      logger.info "Validation failed for one or more legal signatory updates for organisation ID: #{@organisation.id}"

      log_errors(@organisation)

      render :show

    end
  end

  private

  def organisation_params
    params.require(:organisation).permit(
      legal_signatories_attributes: [
        :id,
        :name,
        :email_address,
        :phone_number
      ]
    )
  end
end
