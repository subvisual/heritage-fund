require "rails_helper"

RSpec.describe FundingApplication::GpProject::DescriptionController do
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
    it "should raise a ParameterMissing error if no params are passed" do
      expect {
        put :update,
          params: {
            application_id: funding_application.id
          }
      }.to raise_error(
        ActionController::ParameterMissing,
        "param is missing or the value is empty: project"
      )
    end

    it "should raise a ParameterMissing error if an empty project param " \
        "is passed" do
      expect {
        put :update,
          params: {
            application_id: funding_application.id,
            project: {}
          }
      }.to raise_error(
        ActionController::ParameterMissing,
        "param is missing or the value is empty: project"
      )
    end

    it "should re-render the page if an empty description param is passed" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            description: ""
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.description.blank"))
    end

    it "should re-render the page if project description param is over 500 " \
       "words" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            description: "word " * 501
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(
        assigns(:funding_application).project.errors.messages[:description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.description.too_long"))
    end

    it "should successfully update if a valid param is passed" do
      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            description: "Test description"
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_capital_works)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.description).to eq("Test description")
    end
  end
end
