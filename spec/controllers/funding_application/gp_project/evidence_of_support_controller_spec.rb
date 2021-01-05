require "rails_helper"

RSpec.describe FundingApplication::GpProject::EvidenceOfSupportController do
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
    it "should raise a ParameterMissing error if no project param is passed" do
      expect {
        put :update,
          params: {application_id: funding_application.id}
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

    it "should re-render the page if an empty description attribute is " \
       "passed" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            evidence_of_support_attributes: {
              "0": {
                description: ""
              }
            }
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.evidence_of_support.first.errors.empty?)
        .to eq(false)
      expect(assigns(:funding_application).project.evidence_of_support.first.errors.messages[:description][0])
        .to eq(I18n.t("activerecord.errors.models.evidence_of_support.attributes.description.blank"))
      expect(assigns(:funding_application).project.evidence_of_support.first.errors.messages[:evidence_of_support_files][0])
        .to eq("Add an evidence of support file")
    end

    it "should re-render the page if a description attribute over 50 words" \
       " is passed" do
      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            evidence_of_support_attributes: {
              "0": {
                description: "word " * 51
              }
            }
          }
        }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.evidence_of_support.first.errors.empty?)
        .to eq(false)
      expect(assigns(:funding_application).project.evidence_of_support.first.errors.messages[:description][0])
        .to eq(I18n.t("activerecord.errors.models.evidence_of_support.attributes.description.too_long"))
      expect(assigns(:funding_application).project.evidence_of_support.first.errors.messages[:evidence_of_support_files][0])
        .to eq("Add an evidence of support file")
    end

    it "should successfully update and redirect to the same page if valid " \
       "params are passed" do
      put :update,
        params: {
          application_id: funding_application.id,
          project: {
            evidence_of_support_attributes: {
              "0": {
                description: "Test",
                evidence_of_support_files:
                        Rack::Test::UploadedFile.new(
                          Rails.root + "spec/fixtures/files/example.txt"
                        )
              }
            }
          }
        }

      expect(response).to have_http_status(:redirect)
      expect(response)
        .to redirect_to(:funding_application_gp_project_evidence_of_support)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.evidence_of_support.first.errors.empty?)
        .to eq(true)
      expect(assigns(:funding_application).project.evidence_of_support.first.description)
        .to eq("Test")
      expect(assigns(:funding_application).project.evidence_of_support.first.evidence_of_support_files.attached?)
        .to eq(true)
    end
  end

  describe "DELETE #delete" do
    it "should redirect to root for an invalid project" do
      delete :delete,
        params: {
          application_id: "invalid",
          supporting_evidence_id: "invalid"
        }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

    it "should fail to find an invalid supporting_evidence_id and redirect " \
       "back" do
      expect {
        delete :delete,
          params: {
            application_id: funding_application.id,
            supporting_evidence_id: "invalid"
          }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should delete a valid supporting_evidence_id and redirect back" do
      evidence_of_support = create(
        :evidence_of_support,
        project_id: funding_application.project.id,
        description: "Test",
        evidence_of_support_files: Rack::Test::UploadedFile.new(
          Rails.root + "spec/fixtures/files/example.txt"
        )
      )

      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).ordered
      expect(Rails.logger)
        .to receive(:info).at_least(:once)
        .with("Deleting supporting evidence ID: " \
                        "#{evidence_of_support.id}")

      expect {
        delete :delete,
          params: {
            application_id: funding_application.id,
            supporting_evidence_id: evidence_of_support.id
          }
      }.to change(funding_application.project.evidence_of_support, :count).by(-1)

      expect(response).to have_http_status(:redirect)
      expect(response)
        .to redirect_to(:funding_application_gp_project_evidence_of_support)
    end
  end
end
