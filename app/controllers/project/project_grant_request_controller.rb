class Project::ProjectGrantRequestController < ApplicationController
  include ProjectContext

  def show

    calculate_total_project_cost

    calculate_total_cash_contributions

    @final_grant_amount = @total_project_cost - @total_cash_contributions

  end


  private
  def calculate_total_project_cost

    logger.debug "Calculating total project cost for project ID: #{@project.id}"

    @total_project_cost = 0

    logger.debug "Retrieving all project costs for project ID: #{@project.id}"

    ProjectCost.where(project_id: @project.id).find_each do |project_cost|

      logger.debug "Retrieved project cost ID #{project_cost.id}, amount #{project_cost.amount} " +
                       "for project ID: #{@project.id}"

      @total_project_cost += project_cost.amount

      logger.debug "Running total project cost for project ID: #{@project.id} is: #{@total_project_cost}"

    end

    logger.debug "Calculated total project cost of #{@total_project_cost} for project ID: #{@project.id}"

  end

  private
  def calculate_total_cash_contributions

    logger.debug "Calculating total cash contributions for project ID: #{@project.id}"

    @total_cash_contributions = 0

    logger.debug "Retrieving all cash contributions for project ID: #{@project.id}"

    CashContribution.where(project_id: @project.id).find_each do |cash_contribution|

      logger.debug "Retrieved cash contribution ID #{cash_contribution.id}, amount #{cash_contribution.amount} " +
                       "for project ID: #{@project.id}"

      @total_cash_contributions += cash_contribution.amount

      logger.debug "Running total cash contributions for project ID: #{@project.id} is: #{@total_cash_contributions}"

    end

    logger.debug "Calculated total cash contributions of #{@total_cash_contributions} for project ID: #{@project.id}"

  end

end
