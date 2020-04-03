require "rails_helper"

RSpec.describe DashboardController do

  describe "GET #health" do
    login_user

    it "should render the :show template if all user properties " \
       " are populated" do

      get :show

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)

    end

    it "should redirect if not all user properties are populated" do

      subject.current_user.update(name: nil)

      get :show

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(:user_details)
    end

  end

end