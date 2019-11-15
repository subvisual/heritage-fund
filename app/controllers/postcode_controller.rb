require 'ideal_postcodes'
require 'pry'
class PostcodeController < ApplicationController
    def show
    end
    
    def lookup
        IdealPostcodes.api_key = ENV['IDEAL_POSTCODES_API_KEY']
        begin
           @response = IdealPostcodes::Postcode.lookup "ID1 1QD"
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
        respond_to do |format|
            format.json {
                render json: @response.to_json
            }
        end
    
    end
end
