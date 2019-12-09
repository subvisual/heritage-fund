class HealthController < ApplicationController

    # Returns application status and the current server timestamp
    #
    # @return [JSON] a JSON object containing the application status
    #                and the current server timestamp
    def get_status
        render :json => {
            'status' => 'OK',
            'server_timestamp' => Time.new.strftime("%Y-%m-%d %H:%M:%S")
        },
        :status => 200
    end
end