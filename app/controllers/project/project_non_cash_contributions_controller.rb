class Project::ProjectNonCashContributionsController < ApplicationController
  include ProjectContext

  def show
    @non_cash_contributions = @project.non_cash_contributions.build
  end

  def update

    # TODO: Validate params
    @project.update(project_params)

    redirect_to three_to_ten_k_project_project_non_cash_contributions_path

  end

  private

  def project_params
    params.require(:project).permit(non_cash_contributions_attributes: [:description, :amount])
  end

end
