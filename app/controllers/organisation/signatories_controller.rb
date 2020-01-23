class Organisation::SignatoriesController < ApplicationController
  include OrganisationContext
  before_action :set_legal_signatories

  def update

    logger.debug "Updating legal signatories for organisation ID: #{@organisation.id}"

    set_signatory_validation_paramaters

    signatory_validation_statuses = []

    @legal_signatories.each do |signatory|

      logger.debug "Assigning attributes for legal signatory ID: #{signatory.id}"

      signatory.assign_attributes({
                           name: params[:legal_signatories][signatory.id][:name],
                           email_address: params[:legal_signatories][signatory.id][:email_address],
                           phone_number: params[:legal_signatories][signatory.id][:phone_number]
                       })

      logger.debug "Finished assigning attributes for legal signatory ID: #{signatory.id}"

      signatory_validation_statuses << signatory.valid?

    end

    if signatory_validation_statuses.include?(false)

      logger.debug "Validation checks failed for one or more legal signatory updates"

      render :show

    else

      logger.debug "Finished updating legal signatories for organisation ID: #{@organisation.id}"

      @legal_signatories.each do |signatory|
        signatory.save
      end

      redirect_to :organisation_summary

    end

  end

  private

  def set_legal_signatories

    @legal_signatories = LegalSignatory.where(organisation_id: @organisation.id)

    if @legal_signatories.present?

      logger.debug "Found existing legal signatories for organisation ID: #{@organisation.id}"

    else

      logger.debug "Creating legal signatories for organisation ID: #{@organisation.id}"

      @legal_signatories = [LegalSignatory.create(organisation_id: @organisation.id),
                            LegalSignatory.create(organisation_id: @organisation.id)]

      logger.debug "Finished creating legal signatories for organisation ID: #{@organisation.id}"

    end

  end

  def set_signatory_validation_paramaters

    # The first legal signatory is mandatory, so enable validation
    @legal_signatories[0].validate_name = true
    @legal_signatories[0].validate_email_address = true
    @legal_signatories[0].validate_phone_number = true

    # Only enable validation for the second legal signatory if any attributes have been passed
    if (
    params[:legal_signatories][params[:legal_signatories].keys[1]][:name].present? ||
        params[:legal_signatories][params[:legal_signatories].keys[1]][:email_address].present? ||
        params[:legal_signatories][params[:legal_signatories].keys[1]][:phone_number].present?
    )
      @legal_signatories[1].validate_name = true
      @legal_signatories[1].validate_email_address = true
      @legal_signatories[1].validate_phone_number = true
    end

  end

end
