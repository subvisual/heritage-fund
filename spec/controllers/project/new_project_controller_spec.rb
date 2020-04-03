require "rails_helper"

RSpec.describe Project::NewProjectController do
  login_user

  describe "GET #create_new_project" do

    it "should successfully create a project and redirect" do
      get :create_new_project
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(
                              three_to_ten_k_project_title_get_path(
                                  project_id: assigns(:project).id)
                          )
      expect(assigns(:project)).to be_instance_of(Project)
    end

  end

end

