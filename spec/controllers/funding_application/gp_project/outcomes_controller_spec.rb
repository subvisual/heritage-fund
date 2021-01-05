require "rails_helper"

RSpec.describe FundingApplication::GpProject::OutcomesController do
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
          params: {application_id: funding_application.id}
      }.to raise_error(ActionController::ParameterMissing)
    end

    it "should raise a ParameterMissing error if an empty project param is " \
       "passed" do
      expect {
        put :update,
          params: {
            application_id: funding_application.id,
            project: {}
          }
      }.to raise_error(ActionController::ParameterMissing)
    end

    it "should re-render the page if any description param is over 500 words" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            outcome_2: "true",
            outcome_3: "true",
            outcome_4: "true",
            outcome_5: "true",
            outcome_6: "true",
            outcome_7: "true",
            outcome_8: "true",
            outcome_9: "true",
            outcome_2_description: "word " * 301,
            outcome_3_description: "word " * 301,
            outcome_4_description: "word " * 301,
            outcome_5_description: "word " * 301,
            outcome_6_description: "word " * 301,
            outcome_7_description: "word " * 301,
            outcome_8_description: "word " * 301,
            outcome_9_description: "word " * 301
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)

      (2..9).each do |i|
        expect(assigns(:funding_application).project.errors
                   .messages[:"outcome_#{i}_description"][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.outcome_description.too_long"))
      end
    end

    it "should successfully update if valid outcomes are passed" do
      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            outcome_2: "false",
            outcome_3: "false",
            outcome_4: "false",
            outcome_5: "false",
            outcome_6: "false",
            outcome_7: "false",
            outcome_8: "false",
            outcome_9: "false"
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_costs)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)

      expect(assigns(:funding_application).project.outcome_2).to eq(false)
      expect(assigns(:funding_application).project.outcome_3).to eq(false)
      expect(assigns(:funding_application).project.outcome_4).to eq(false)
      expect(assigns(:funding_application).project.outcome_5).to eq(false)
      expect(assigns(:funding_application).project.outcome_6).to eq(false)
      expect(assigns(:funding_application).project.outcome_7).to eq(false)
      expect(assigns(:funding_application).project.outcome_8).to eq(false)
      expect(assigns(:funding_application).project.outcome_9).to eq(false)
    end

    it "should successfully update if both valid outcomes and descriptions " \
       "are passed" do
      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            outcome_2: "true",
            outcome_3: "false",
            outcome_4: "true",
            outcome_5: "false",
            outcome_6: "true",
            outcome_7: "false",
            outcome_8: "true",
            outcome_9: "false",
            outcome_2_description: "test 2",
            outcome_4_description: "test 4",
            outcome_6_description: "test 6",
            outcome_8_description: "test 8",
            outcome_9_description: "test 9"
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_costs)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)

      expect(assigns(:funding_application).project.outcome_2).to eq(true)
      expect(assigns(:funding_application).project.outcome_3).to eq(false)
      expect(assigns(:funding_application).project.outcome_4).to eq(true)
      expect(assigns(:funding_application).project.outcome_5).to eq(false)
      expect(assigns(:funding_application).project.outcome_6).to eq(true)
      expect(assigns(:funding_application).project.outcome_7).to eq(false)
      expect(assigns(:funding_application).project.outcome_8).to eq(true)
      expect(assigns(:funding_application).project.outcome_9).to eq(false)

      expect(assigns(:funding_application).project.outcome_2_description).to eq("test 2")
      expect(assigns(:funding_application).project.outcome_4_description).to eq("test 4")
      expect(assigns(:funding_application).project.outcome_6_description).to eq("test 6")
      expect(assigns(:funding_application).project.outcome_8_description).to eq("test 8")

      # We expect this to be nil, as the controller removes descriptions
      # where the outcome has been set to 'false'
      expect(assigns(:funding_application).project.outcome_9_description).to eq(nil)
    end
  end
end
