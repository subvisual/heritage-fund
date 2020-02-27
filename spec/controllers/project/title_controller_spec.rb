require "rails_helper"

describe Project::TitleController do
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

    it "should re-render the page if an empty project_title param is passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update, params: {
          project_id: project.id,
          project: {
              project_title: ""
          }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:project_title][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.project_title.blank"))

    end

    it "should re-render the page if project_title param over 255 characters " \
       "in length is passed" do

      expect(subject).to \
        receive(:log_errors).with(project)

      put :update, params: {
          project_id: project.id,
          project: {
              project_title: "0" * 256
          }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:project_title][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.project_title.too_long"))

    end

    it "should successfully update if a valid param is passed" do

      put :update, params: {
          project_id: project.id,
          project: {
              project_title: "Test project title"
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_dates_get)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).project_title).to eq("Test project title")

    end

  end

end