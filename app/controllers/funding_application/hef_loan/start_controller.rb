class FundingApplication::HefLoan::StartController < ApplicationController
  before_action :authenticate_user!

  # Method used to create new FundingApplication and GpHefLoan objects
  # before redirecting the user to :funding_application_hef_loan_application_form
  def update

    @application = FundingApplication.create(
      organisation_id: current_user.organisation.id
    )

    GpHefLoan.create(funding_application_id: @application.id)

    redirect_to(
      funding_application_hef_loan_application_form_path(
        @application.id
      )
    )

  end

end
