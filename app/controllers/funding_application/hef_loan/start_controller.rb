class FundingApplication::HefLoan::StartController < ApplicationController
    before_action :authenticate_user!

    def update

        @application = FundingApplication.create(organisation_id: current_user.organisation.id)

        redirect_to funding_application_hef_loan_form_path @application.id

    end
end
