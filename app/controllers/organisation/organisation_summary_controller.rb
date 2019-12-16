class Organisation::OrganisationSummaryController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show

    @organisation = Organisation.find(params[:organisation_id])
    @legal_signatories = LegalSignatory.where(organisation_id: @organisation.id)

  end

end
