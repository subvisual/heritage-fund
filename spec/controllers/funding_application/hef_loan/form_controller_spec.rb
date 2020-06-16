require "rails_helper"

RSpec.describe FundingApplication::HefLoan::FormController do
  login_user

  describe 'GET #show' do

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

    it 'should render the page successfully' do

      subject.current_user.update(organisation: organisation)

      application = create(:funding_application, id: 'id', organisation_id: organisation.id)

      get :show, params: {application_id: application.id}
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

    end

  end

end
