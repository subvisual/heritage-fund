require "rails_helper"

RSpec.describe OrganisationContext do

  # To test our controller concerns, we use the concept of an anonymous
  # controller, which allows us to access RSpec methods and helpers.

  controller(ApplicationController) do
    include OrganisationContext

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
      get 'fake_action/:organisation_id' => 'anonymous#fake_action'
    }
  }

  describe "set_organisation failure scenario" do
    login_user

    before {
      get :fake_action,
          params: {
              organisation_id: 100
          }
    }

    it "should redirect to root if the organisation does not belong " \
       "to the current user" do

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:root)

    end

  end

  describe "set_organisation success scenario" do
    login_user

    before {

      get :fake_action,
          params: {
              organisation_id: subject.current_user.organisation.id
          }

    }

    it "should assign the @organisation instance variable if the " \
        "organisation belongs to the current user" do

      create(:organisation)

      expect(assigns(:organisation)).to eq(subject.current_user.organisation)

    end

  end

end
