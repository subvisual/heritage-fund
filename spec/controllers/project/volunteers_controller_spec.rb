require "rails_helper"

describe Project::VolunteersController do
  login_user
  let(:project) { create(:project, id: "id", user_id: subject.current_user.id) }

  describe "GET #show" do

    it "should render the page successfully for a valid project" do
      get :show,
          params: { project_id: project.id }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
      expect(assigns(:project).errors.empty?).to eq(true)
    end

    it "should redirect to root for an invalid project" do
      get :show, params: { project_id: "invalid" }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)
    end

  end

  describe "PUT #put" do

    it "should raise a ParameterMissing error if no project param is passed" do

      expect {
        put :update,
            params: { project_id: project.id }
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
                project_id: project.id,
                project: { }
            }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should re-render the page if empty description and hours " \
       "attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  volunteers_attributes: {
                      "0": {
                          description: "",
                          hours: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.messages[:hours][0])
          .to eq(I18n.t("activerecord.errors.models.volunteer.attributes.hours.not_a_number"))
      expect(assigns(:project).volunteers.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.volunteer.attributes.description.blank"))

    end

    it "should re-render the page with a flash message if populated " \
       "description and empty hours attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  volunteers_attributes: {
                      "0": {
                          description: "Test",
                          hours: ""
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:description]).to eq("Test")

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.messages[:hours][0])
          .to eq(I18n.t("activerecord.errors.models.volunteer.attributes.hours.not_a_number"))

    end

    it "should re-render the page with a flash message if empty " \
       "description and populated hours attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  volunteers_attributes: {
                      "0": {
                          description: "",
                          hours: "5"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:hours]).to eq("5")

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.messages[:description][0])
          .to eq(I18n.t("activerecord.errors.models.volunteer.attributes.description.blank"))

    end

    it "should re-render the page with a flash message if populated " \
       "description and invalid hours attributes are passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  volunteers_attributes: {
                      "0": {
                          description: "Test",
                          hours: "string"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:description]).to eq("Test")

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.messages[:hours][0])
          .to eq(I18n.t("activerecord.errors.models.volunteer.attributes.hours.not_a_number"))

    end

    it "should re-render the page with a flash message if populated " \
       "description and an hours attribute containing a negative number are " \
       "passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update,
          params: {
              project_id: project.id,
              project: {
                  volunteers_attributes: {
                      "0": {
                          description: "Test",
                          hours: "-50"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(subject.request.flash[:description]).to eq("Test")
      expect(subject.request.flash[:hours]).to eq("-50")

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.empty?).to eq(false)
      expect(assigns(:project).volunteers.first.errors.messages[:hours][0])
          .to eq(I18n.t("activerecord.errors.models.volunteer.attributes.hours.greater_than"))

    end

    it "should successfully update if valid description and hours attributes " \
       "are passed" do

      put :update,
          params: {
              project_id: project.id,
              project: {
                  volunteers_attributes: {
                      "0": {
                          description: "Test",
                          hours: "5"
                      }
                  }
              }
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_volunteers)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).volunteers.first.errors.empty?).to eq(true)
      expect(assigns(:project).volunteers.first.description).to eq("Test")
      expect(assigns(:project).volunteers.first.hours).to eq(5)

    end

  end

  describe "DELETE #delete" do

    it "should redirect to root for an invalid project" do

      delete :delete,
             params: {
               project_id: "invalid",
               volunteer_id: "invalid"
             }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)

    end

    it "should fail to find an invalid volunteer and redirect back" do

      expect {
        delete :delete,
               params: {
                   project_id: project.id,
                   volunteer_id: "invalid"
               }
      }.to raise_error(ActiveRecord::RecordNotFound)

    end

    it "should delete a valid volunteer and redirect back" do

      volunteer = create(
          :volunteer,
          project_id: project.id,
          description: "Test",
          hours: 10
      )

      allow(Rails.logger).to receive(:info)
      expect(Rails.logger).to receive(:info).ordered
      expect(Rails.logger)
          .to receive(:info).at_least(:once)
                  .with("Deleting volunteer ID: #{volunteer.id}")

      expect {
        delete :delete,
               params: {
                   project_id: project.id,
                   volunteer_id: volunteer.id
               }
      }.to change(project.volunteers, :count).by(-1)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_volunteers)

    end

  end

end
