require "rails_helper"

RSpec.describe ProjectContext do

  # To test our controller concerns, we use the concept of an anonymous
  # controller, which allows us to access RSpec methods and helpers.

  controller(ApplicationController) do
    include ProjectContext

    # Our anonymous controller will need a route, and this route will need
    # to be able to hit a method, which we are defining here.
    def fake_action
      redirect_to("/url")
    end

  end

  before {
    routes.draw {
      # Here we are defining the route for our anonymous controller, and
      # directing it to the method we have created for our anonymous controller
      get 'fake_action/:project_id' => 'anonymous#fake_action'
    }
  }

  describe "set_project failure scenario - invalid project" do
    login_user

    before {
      get :fake_action,
          params: {
              project_id: 100
          }
    }

    it "should redirect to root if the project does not belong " \
       "to the current user" do

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)

    end

  end

  describe "set_project failure scenario - submitted project" do
    login_user

    let(:project) {
      create(
          :project,
          id: "id",
          user_id: subject.current_user.id,
          submitted_on: Date.new
      )
    }

    before {
      get :fake_action,
          params: {
              project_id: project.id
          }
    }

    it "should redirect to root if the project belonging to the current user " \
       "has been submitted" do

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)

    end

  end

  describe "set_project success scenario" do
    login_user

    let(:project) {
      create(:project, id: "id", user_id: subject.current_user.id)
    }

    before {
      get :fake_action,
          params: {
              project_id: project.id
          }
    }

    it "should assign the @project instance variable if the project belongs " \
        "to the current user and has not been submitted" do

      expect(assigns(:project)).to eq(project)

    end

  end

end

