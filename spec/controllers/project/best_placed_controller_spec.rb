require "rails_helper"

RSpec.describe Project::BestPlacedController do
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

    it "should redirect to the next page if no params are passed" do

      put :update,
          params: { project_id: project.id }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_how_will_your_project_involve_people)

      expect(assigns(:project).errors.empty?).to eq(true)

    end

    it "should redirect to the next page if an empty best_placed_description" \
       " param is passed" do

      put :update,
          params: {
              project_id: project.id,
              best_placed_description: ""
          }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_how_will_your_project_involve_people)

      expect(assigns(:project).errors.empty?).to eq(true)

    end

    it "should re-render the page if project best_placed_description param " \
       "is over 500 words" do

      expect(subject).to \
         receive(:log_errors).with(project)

      put :update, params: {
          project_id: project.id,
          project: {
              best_placed_description: "word " * 501
          }
      }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

      expect(assigns(:project).errors.empty?).to eq(false)
      expect(
          assigns(:project).errors.messages[:best_placed_description][0]
      ).to eq(I18n.t("activerecord.errors.models.project.attributes.best_placed_description.too_long"))

    end

    it "should successfully update if a valid param is passed" do

      put :update, params: {
          project_id: project.id,
          project: {
              best_placed_description: "Test"
          }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:three_to_ten_k_project_how_will_your_project_involve_people)

      expect(assigns(:project).errors.empty?).to eq(true)
      expect(assigns(:project).best_placed_description).to eq("Test")

    end

  end

end
