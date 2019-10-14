class OrganisationController < ApplicationController
    include Secured

    def index
    end


def new
    @organisation = Organisation.new
  end

end
