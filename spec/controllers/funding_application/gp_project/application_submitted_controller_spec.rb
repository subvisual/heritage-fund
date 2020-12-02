require "rails_helper"

RSpec.describe FundingApplication::GpProject::ApplicationSubmittedController do

  login_user

  let(:funding_application) {
    create(
      :funding_application,
      organisation: subject.current_user.organisations.first
    )
  }

  describe "GET #show" do

    it "should render the page successfully for a valid project" do
      get :show,
          params: { application_id: funding_application.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :show, params: { application_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

end
