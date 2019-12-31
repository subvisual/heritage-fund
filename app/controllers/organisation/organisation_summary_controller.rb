class Organisation::OrganisationSummaryController < ApplicationController
  include OrganisationHelper
  before_action :authenticate_user!, :set_organisation

  def show
  end

end