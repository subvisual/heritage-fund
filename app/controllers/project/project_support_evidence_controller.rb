class Project::ProjectSupportEvidenceController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  def put

    logger.info "Adding evidence of support for project ID: #{@project.id}"

    @project.validate_evidence_of_support = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished adding evidence of support for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_project_support_evidence_path

    else

      logger.info "Validation failed when adding evidence of support for project ID: #{@project.id}"

      log_errors(@project)

      render :show

    end

    @has_file_upload = true

  end

  def delete

    logger.debug "User has selected to delete supporting evidence ID: #{params[:supporting_evidence_id]} from project ID: #{@project.id}"

    supporting_evidence = EvidenceOfSupport.find(params[:supporting_evidence_id])

    logger.debug "Deleting supporting evidence ID: #{supporting_evidence.id}"

    supporting_evidence.destroy if supporting_evidence.project_id == @project.id

    logger.debug "Finished deleting supporting evidence ID: #{supporting_evidence.id}"

    redirect_to three_to_ten_k_project_project_support_evidence_path

  end

  private
  def project_params
    params.require(:project).permit(evidence_of_support_attributes: [:description, :evidence_of_support_files])
  end
end