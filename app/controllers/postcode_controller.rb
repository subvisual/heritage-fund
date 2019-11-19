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
        puts(params)
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
    puts(@response)  
end


    def set_api_key
        IdealPostcodes.api_key = ENV['IDEAL_POSTCODES_API_KEY']
    end

end
