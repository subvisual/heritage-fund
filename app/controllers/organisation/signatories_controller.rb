class Organisation::SignatoriesController < ApplicationController
  include OrganisationContext, ObjectErrorsLogger

  def show

    @organisation.legal_signatories.build unless
        @organisation.legal_signatories.first.present?
    @organisation.legal_signatories.build unless
        @organisation.legal_signatories.second.present?

  end

  def update

    logger.info "Updating legal signatories for organisation ID: " \
                 "#{@organisation.id}"

    @organisation.validate_legal_signatories = true

    @organisation.update(organisation_params)

    if @organisation.valid?

      # See method documentation for description of why this is necessary
      remove_empty_signatory

      logger.info "Finished updating legal signatories for organisation ID: " \
                   "#{@organisation.id}"

      redirect_to :organisation_summary

    else

      logger.info "Validation failed for one or more legal signatory " \
                   "updates for organisation ID: #{@organisation.id}"

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

  private
  # Method used to remove the empty second legal signatory object created
  # by the nested form. This is necessary as it doesn't seem to be possible
  # to validate a first nested object and reject the second if no params have
  # been filled. We can refactor to simply reject both when mandatory
  # entry of at least one signatory has been removed from this page
  def remove_empty_signatory

    unless @organisation.legal_signatories.second.name.present? &&
        @organisation.legal_signatories.second.email_address.present? &&
        @organisation.legal_signatories.second.phone_number.present?

      @organisation.legal_signatories.second.destroy

    end

  end

end
