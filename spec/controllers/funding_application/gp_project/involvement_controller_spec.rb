require "rails_helper"

RSpec.describe FundingApplication::GpProject::InvolvementController do
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
    it "should re-render the page if no params are passed" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:involvement_description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.involvement_description.blank"))
    end

    it "should re-render the page if an empty project param is passed" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {}
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:involvement_description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.involvement_description.blank"))
    end

    it "should re-render the page if an empty involvement_description param " \
       "is passed" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            involvement_description: ""
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:involvement_description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.involvement_description.blank"))
    end

    it "should re-render the page if involvement_description param is over " \
       "300 words" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            involvement_description: "word " * 301
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:involvement_description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.involvement_description.too_long"))
    end

    it "should successfully update if a valid param is passed" do
      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            involvement_description: "Test"
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_our_other_outcomes)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.involvement_description).to eq("Test")
    end
  end
end
