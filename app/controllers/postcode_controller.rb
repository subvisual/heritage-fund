require 'ideal_postcodes'
require 'pry'
class PostcodeController < ApplicationController
    before_action :set_api_key

    def lookup
        begin
           @response = IdealPostcodes::Postcode.lookup params['postcode']['lookup']
        rescue IdealPostcodes::AuthenticationError => e
                # Invalid API Key
        rescue IdealPostcodes::TokenExhaustedError => e
            # Token has run out of lookups
        rescue IdealPostcodes::LimitReachedError => e
            # One of your predefinied limits has been reached
        rescue IdealPostcodes::IdealPostcodesError => e
            # API Error
        rescue => e
            # An unexpected error
        end

        respond_to do |format|
            # format.json {
            #     render json: @response.to_json
            # }
            format.html {
                render :results
            }
        end
    end
    def save
    begin
        @response = IdealPostcodes::Address.lookup params[:address]
    rescue IdealPostcodes::AuthenticationError => e
            # Invalid API Key
    rescue IdealPostcodes::TokenExhaustedError => e
    # Token has run out of lookups
    rescue IdealPostcodes::LimitReachedError => e
        # One of your predefinied limits has been reached
    rescue IdealPostcodes::IdealPostcodesError => e
        # API Error
    rescue => e
        # An unexpected error
    end
    
    @user = User.current_user(session[:user_id])
    @user.organisation.line1 = @response.fetch(:line_1)
    @user.organisation.line2 = @response.fetch(:line_2)
    @user.organisation.line3 = @response.fetch(:line_3)
    @user.organisation.postcode = @response.fetch(:postcode)
    @user.organisation.townCity = @response.fetch(:post_town)
    @user.organisation.county = @response.fetch(:county)
    @user.organisation.save
end


    def set_api_key
        IdealPostcodes.api_key = ENV['IDEAL_POSTCODES_API_KEY']
    end

end
