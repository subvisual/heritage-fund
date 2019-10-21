class ReleasedFormController < ApplicationController
    protect_from_forgery with: :null_session
    def receive
        puts('in here')
        puts(params['Status'])
    end
end
