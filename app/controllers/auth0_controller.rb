class Auth0Controller < ApplicationController
    def callback
        @user = User.find_or_create_from_auth_hash(auth_hash)
        puts(@user)
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
