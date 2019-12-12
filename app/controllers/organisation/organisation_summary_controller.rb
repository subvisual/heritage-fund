class Organisation::OrganisationSummaryController < ApplicationController

  before_action :authenticate_user!

  def show

    @organisation = Organisation.find(params[:organisation_id])

  end

end
