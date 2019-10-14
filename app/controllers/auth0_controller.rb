class Auth0Controller < ApplicationController
    def callback
        session[:user_id] = auth_hash.uid
        @user = User.find_or_create_from_auth_hash(auth_hash)
        redirect_to '/dashboard'
    end

    protected 

    def auth_hash
        request.env['omniauth.auth']

    end
    
    def failure
        @error_msg = request.params['message']     
    end
end
