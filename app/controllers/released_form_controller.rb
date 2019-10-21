class ReleasedFormController < ApplicationController
    protect_from_forgery with: :null_session
    def receive
       @project = Project.find(params[:ApplicationId])
        if params[:Status] == 'Awarded' 
            @project.released_forms.create(payload: params, form_type: 'permission-to-start')
        end
    end
end
