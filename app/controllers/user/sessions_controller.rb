# Overrides the Devise SessionsController to introduce custom functionality
class User::SessionsController < Devise::SessionsController

  # GET /resource/sign_in
  # Override to inject tracking parameter
  def new
    gon.push({ tracking_url_path: '/sign-in' })
    super
  end

end
