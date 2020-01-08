class Project::ProjectSupportEvidenceController < ApplicationController

  include ProjectContext

  def project_support_evidence

  end

  def put

    @project.evidence_description.push(params[:project][:evidence_description]) if params[:project][:evidence_description].present?
    @project.evidence_of_support_files.attach(params[:project][:evidence_of_support_files]) if params[:project][:evidence_of_support_files].present?
    @project.save
    redirect_to three_to_ten_k_project_project_support_evidence_path(@project.id)

  end

  private

  def project_params
    params.require(:project).permit(:evidence_description, :evidence_of_support_files[])
  end
end