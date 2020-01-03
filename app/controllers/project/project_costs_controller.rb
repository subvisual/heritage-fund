class Project::ProjectCostsController < ApplicationController
  include ProjectContext

  def show
    @project_cost = @project.project_costs.build
  end

  def update
    # TODO: Add Validation
    @project.update(project_params)
    redirect_to three_to_ten_k_project_project_costs_path
  end

  private
  def project_params
    params.require(:project).permit(project_costs_attributes: [:description, :amount, :cost_type])
  end
end
