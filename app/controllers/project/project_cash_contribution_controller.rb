class Project::ProjectCashContributionController < ApplicationController

  include ProjectContext

  def project_cash_contribution
    @cash_contribution = @project.cash_contributions.build
  end


  def put
    # TODO: Validate fields
    @project.update(project_params)
    redirect_to three_to_ten_k_project_project_cash_contribution_path
  end

  private
  def project_params
    params.require(:project).permit(cash_contributions_attributes: [:description, :secured, :amount, :cash_contribution_evidence_files])
  end


end
