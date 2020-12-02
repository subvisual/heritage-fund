require "rails_helper"

RSpec.describe FundingApplication::GpProject::NonCashContributionsController do

  login_user

  let(:funding_application) {
    create(
      :funding_application,
      organisation: subject.current_user.organisations.first
    )
  }

  describe "GET #question" do

    it "should render the page successfully for a valid project" do
      get :question,
          params: { application_id: funding_application.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)
      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :question, params: { application_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

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

  describe "PUT #update_question" do

    it "should re-render the page if no project param is passed" do

      put :question_update,
          params: { application_id: funding_application.id }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.errors.messages[:non_cash_contributions_question][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.non_cash_contributions_question.inclusion"))

    end

    it "should re-render the page if an empty project param is passed" do

      put :question_update,
          params: {
              application_id: funding_application.id,
              project: { }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.errors.messages[:non_cash_contributions_question][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.non_cash_contributions_question.inclusion"))

    end

    it "should re-render the page if an invalid " \
       "non_cash_contributions_question param is passed" do

      put :question_update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_question: "invalid"
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:question)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.errors.messages[:non_cash_contributions_question][0])
          .to eq(I18n.t("activerecord.errors.models.project.attributes.non_cash_contributions_question.inclusion"))

    end

    it "should successfully redirect if a valid " \
       "non_cash_contributions_question param of 'false' is passed" do

      put :question_update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_question: "false"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:funding_application_gp_project_volunteers)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)

    end

    it "should successfully redirect if a valid " \
       "non_cash_contributions_question param of 'true' is passed" do

      put :question_update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_question: "true"
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:funding_application_gp_project_non_cash_contributions)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)

    end

  end

  describe "PUT #update" do

    it "should raise a ParameterMissing error if no project param is passed" do

      expect {
        put :update,
            params: { application_id: funding_application.id }
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
                project: { }
            }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should re-render the page if empty description and amount " \
       "attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.empty?)
          .to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.amount.not_a_number"))
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.description.blank"))

    end

    it "should re-render the page with a flash message if populated " \
       "description and empty amount attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_attributes: {
                      "0": {
                          description: "Test",
                          amount: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:description]).to eq("Test")

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.amount.not_a_number"))

    end

    it "should re-render the page with a flash message if empty " \
       "description and populated amount attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: "5"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:amount]).to eq("5")

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.description.blank"))

    end

    it "should re-render the page with a flash message if an amount param " \
       "containing a string is passed" do

      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: "string"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:amount]).to eq("string")

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.amount.not_a_number"))
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.description.blank"))

    end

    it "should re-render the page with a flash message if an amount param " \
       "containing a negative number is passed" do

      expect(subject).to \
        receive(:log_errors).with(funding_application.project)

      put :update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_attributes: {
                      "0": {
                          description: "",
                          amount: "-50"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:amount]).to eq("-50")

      expect(assigns(:funding_application).project.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.empty?).to eq(false)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:amount][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.amount.greater_than"))
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.non_cash_contribution.attributes.description.blank"))

    end

    it "should successfully update if valid description and amount " \
       "attributes are passed" do

      put :update,
          params: {
              application_id: funding_application.id,
              project: {
                  non_cash_contributions_attributes: {
                      "0": {
                          description: "Test",
                          amount: "5"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:funding_application_gp_project_non_cash_contributions)

      expect(assigns(:funding_application).project.errors.empty?).to eq(true)
      expect(assigns(:funding_application).project.non_cash_contributions.first.errors.empty?)
          .to eq(true)
      expect(assigns(:funding_application).project.non_cash_contributions.first.description)
          .to eq("Test")
      expect(assigns(:funding_application).project.non_cash_contributions.first.amount).to eq(5)

    end

  end

  describe "DELETE #delete" do

    it "should redirect to root for an invalid project" do

      delete :delete,
             params: {
                 application_id: "invalid",
                 non_cash_contribution_id: "invalid"
             }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)

    end

    it "should fail to find an invalid volunteer and redirect back" do

      expect {
        delete :delete,
               params: {
                   application_id: funding_application.id,
                   non_cash_contribution_id: "invalid"
               }
      }.to raise_error(ActiveRecord::RecordNotFound)

    end

    it "should delete a valid volunteer and redirect back" do

      non_cash_contribution = create(
          :non_cash_contribution,
          project_id: funding_application.project.id,
          description: "Test",
          amount: 5
      )

      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).ordered
      expect(Rails.logger)
          .to receive(:info).at_least(:once)
                  .with("Deleting non-cash contribution ID: " \
                        "#{non_cash_contribution.id}")

      expect {
        delete :delete,
               params: {
                   application_id: funding_application.id,
                   non_cash_contribution_id: non_cash_contribution.id
               }
      }.to change(funding_application.project.non_cash_contributions, :count).by(-1)

      expect(response).to have_http_status(:redirect)
      expect(response)
          .to redirect_to(:funding_application_gp_project_non_cash_contributions)

    end

  end

end
