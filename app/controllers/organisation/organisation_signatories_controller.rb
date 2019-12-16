class Organisation::OrganisationSignatoriesController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation, :set_legal_signatories

  def show
    render :signatories
  end

  def update

    logger.debug 'Updating legal signatories for organisation ID: #{@organisation.id}'

    params[:legal_signatories].each do |signatory|

      logger.debug 'Updating existing legal signatory ID: #{signatory[0]}'

      LegalSignatory.update(signatory[0],
                            name: signatory[1]['name'],
                            email_address: signatory[1]['email_address'],
                            phone_number: signatory[1]['phone_number'])

      logger.debug 'Finished updating existing legal signatory ID: #{signatory[0]'

    end

    logger.debug 'Finished updating legal signatories for organisation ID: #{@organisation.id}'

    redirect_to :organisation_organisation_summary_get

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

end
