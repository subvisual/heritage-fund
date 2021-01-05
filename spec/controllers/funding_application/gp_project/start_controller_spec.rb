require "rails_helper"

RSpec.describe FundingApplication::GpProject::StartController do
  login_user

  describe "GET #show" do
    it "should render the page successfully" do
      get :show
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end
end
