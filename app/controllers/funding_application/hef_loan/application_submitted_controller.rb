class FundingApplication::HefLoan::ApplicationSubmittedController < ApplicationController
    include FundingApplicationContext
    around_action :switch_locale
end
