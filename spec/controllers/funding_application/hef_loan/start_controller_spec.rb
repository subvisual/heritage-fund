require "rails_helper"

RSpec.describe FundingApplication::HefLoan::StartController do
  login_user

  describe 'PUT #update' do

    let(:organisation) {
      create(
        :organisation,
        id: '1',
        name: 'Test Organisation',
        line1: '10 Downing Street',
        line2: 'Westminster',
        townCity: 'London',
        county: 'London',
        postcode: 'SW1A 2AA',
        org_type: 1
      )
    }

    it 'should create a new FundingApplication object and redirect to the form page' do

      subject.current_user.update(organisation: organisation)

      put :update

      expect(assigns(:application)).to be_an_instance_of FundingApplication

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(funding_application_hef_loan_form_path(assigns(:application).id))

    end

  end

end
