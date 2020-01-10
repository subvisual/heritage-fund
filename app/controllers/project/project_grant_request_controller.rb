class Project::ProjectGrantRequestController < ApplicationController
  def project_grant_request
    # TODO get project amounts from database when available
    @total_project_cost = 100
    @cash_contributions = 50
    @final_grant_amount = @total_project_cost - @cash_contributions
  end
end

def grant_save_and_continue
  # TODO save if not already in the database
end
