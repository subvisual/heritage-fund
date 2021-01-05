require "rails_helper"

RSpec.describe FundingApplication::GpProject::DifferenceController do
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
        params: {application_id: funding_application.id}
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

  describe "PUT #update" do
    it "should redirect to the next page if no params are passed" do
      put :update,
        params: {application_id: funding_application.id}

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_how_does_your_project_matter)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it "should redirect to the next page if an empty difference" \
        " param is passed" do
      put :update,
        params: {
          application_id: funding_application.id,
          difference: ""
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_how_does_your_project_matter)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it "should re-render the page if project difference param " \
        "is over 500 words" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            difference: "word " * 501
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:difference][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.difference.too_long"))
    end

    it "should successfully update if a valid param is passed" do
      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            difference: "Test"
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_how_does_your_project_matter)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.difference).to eq("Test")
    end
  end
end
