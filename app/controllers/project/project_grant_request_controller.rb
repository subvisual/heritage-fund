class Project::ProjectGrantRequestController < ApplicationController
  include ProjectContext

  def show

    @total_project_cost = helpers.calculate_total(@project.project_costs).to_i
    @total_cash_contributions = helpers.calculate_total(@project.cash_contributions).to_i

    @final_grant_amount = @total_project_cost - @total_cash_contributions

  end

end
