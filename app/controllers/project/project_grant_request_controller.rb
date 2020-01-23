class Project::ProjectGrantRequestController < ApplicationController
  include ProjectContext

  def show

    @total_project_cost = helpers.calculate_total(@project.project_costs)
    @total_cash_contributions = helpers.calculate_total(@project.cash_contributions)

    @final_grant_amount = @total_project_cost.to_i - @total_cash_contributions.to_i

  end

end
