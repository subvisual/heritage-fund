class Project::ProjectGrantRequestController < ApplicationController
  include ProjectContext

  def show

    @total_project_cost = helpers.calculate_total(@project.project_costs).to_i
    @total_cash_contributions = helpers.calculate_total(@project.cash_contributions).to_i
    @final_grant_amount = @total_project_cost - @total_cash_contributions
    @maximum_request_value = 10000.to_i
    @costs_greater_than_contributions = @final_grant_amount.positive? 
    @grant_request_less_than_funding_band = @final_grant_amount <= @maximum_request_value 
    @grant_request_is_valid = @costs_greater_than_contributions && @grant_request_less_than_funding_band ? true : false

  end

end
