# Controller concern used to set the @pre_application
# instance variable
module PreApplicationContext
    extend ActiveSupport::Concern
    included do
      before_action :authenticate_user!, :set_pre_application
    end
  
    # This method retrieves a PreApplication object based on the id
    # found in the URL parameters and the current authenticated
    # user's id, setting it as an instance variable for use in
    # pre application-related controllers.
    #
    # If no PreApplication object matching the parameters is found,
    # then the user is redirected to the applications dashboard.
    def set_pre_application
  
      @pre_application = PreApplication.find_by(
        id: params[:pre_application_id],
        organisation_id: current_user.organisations.first&.id
      )
  
      if !@pre_application.present? || (@pre_application.submitted_on.present? &&
          !request.path.include?('/submitted'))
  
          logger.error("User redirected to root, error in pre_application_context.rb")
  
        redirect_to :authenticated_root
  
      end
  
    end
  
  end
  
