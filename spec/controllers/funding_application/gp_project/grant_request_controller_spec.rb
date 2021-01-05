require "rails_helper"

RSpec.describe FundingApplication::GpProject::GrantRequestController do
  login_user

  let(:funding_application) {
    create(
      :funding_application,
      organisation: subject.current_user.organisations.first
    )
  }

  describe "GET #show" do
    it "should render the page successfully for a valid project with a " \
       "valid grant amount" do
      allow(controller.helpers).to receive(:calculate_total)
        .with(any_args).and_return(5000, 2500)

      get :show,
        params: {application_id: funding_application.id}

      expect(controller.instance_variable_get(:@total_project_cost)).to eq(5000)
      expect(controller.instance_variable_get(:@total_cash_contributions))
        .to eq(2500)
      expect(controller.instance_variable_get(:@final_grant_amount)).to eq(2500)
      expect(controller.instance_variable_get(:@grant_request_is_valid))
        .to eq(true)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it "should render the page successfully for a valid project with an " \
       "invalid grant amount" do
      allow(controller.helpers).to receive(:calculate_total)
        .with(any_args).and_return(5000)

      get :show,
        params: {application_id: funding_application.id}

      expect(controller.instance_variable_get(:@total_project_cost)).to eq(5000)
      expect(controller.instance_variable_get(:@total_cash_contributions))
        .to eq(5000)
      expect(controller.instance_variable_get(:@final_grant_amount)).to eq(0)
      expect(controller.instance_variable_get(:@grant_request_is_valid))
        .to eq(false)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :show, params: {application_id: "invalid"}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end
  end
end
