require "rails_helper"

describe Project::DescriptionController do
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

  describe "PUT #update" do

    it "should raise a ParameterMissing error if no params are passed" do

      expect {
        put :update, params: {
            project_id: project.id
        }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should raise a ParameterMissing error if an empty project param " \
        "is passed" do

      expect {
        put :update, params: {
            project_id: project.id,
            project: {}
        }
      }.to raise_error(
               ActionController::ParameterMissing,
               "param is missing or the value is empty: project"
           )

    end

    it "should re-render the page if an empty description param is passed" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update, params: {
          project_id: project.id,
          project: {
              description: ""
          }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.description.blank"))

    end

    it "should successfully update if a valid param is passed" do

      put :update, params: {
          project_id: project.id,
          project: {
              description: "Test description"
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_capital_works_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).description).to eq("Test description")

    end

  end

end
