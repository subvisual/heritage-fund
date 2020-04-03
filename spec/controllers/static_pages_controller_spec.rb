require "rails_helper"

RSpec.describe StaticPagesController do

  describe "GET #show_accessibility_statement" do
    login_user

    it "should render the correct template if all user properties " \
       " are populated" do

      get :show_accessibility_statement

      expect(response).to have_http_status(:success)
      expect(response).to render_template(
                              "static_pages/accessibility_statement/show"
                          )

    end

  end

end