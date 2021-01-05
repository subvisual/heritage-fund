class FundingApplication::GpProject::EvidenceOfSupportController < ApplicationController
  include ObjectErrorsLogger
  include FundingApplicationContext

  # This method is used to set the @has_file_upload instance variable before
  # rendering the :show template. This is used within the
  # _direct_file_upload_hooks partial
  def show
    @has_file_upload = true
  end

  # This method adds evidence of support to a project, redirecting back to
  # :funding_application_gp_project_evidence_of_support if successful and
  # re-rendering :show method if unsuccessful
  def update
    logger.info "Adding evidence of support for project ID: #{@funding_application.project.id}"

    @funding_application.project.validate_evidence_of_support = true

    @funding_application.project.update(project_params)

    if @funding_application.project.valid?

      logger.info "Finished adding evidence of support for project ID: " \
                  "#{@funding_application.project.id}"

      redirect_to :funding_application_gp_project_evidence_of_support

    else

      logger.info "Validation failed when attempting to add evidence of " \
                  "support for project ID: #{@funding_application.project.id}"

      log_errors(@funding_application.project)

      render :show

    end

    @has_file_upload = true
  end

  # This method deletes evidence of support, redirecting back to
  # :funding_application_gp_project_evidence_of_support once completed
  def delete
    logger.info "User has selected to delete evidence_of_support ID: " \
                "#{params[:supporting_evidence_id]} from project ID: " \
                "#{@funding_application.project.id}"

    evidence_of_support =
      @funding_application.project.evidence_of_support.find(params[:supporting_evidence_id])

    logger.info "Deleting supporting evidence ID: #{evidence_of_support.id}"

    evidence_of_support.destroy

    logger.info "Finished deleting supporting evidence ID: " \
                "#{evidence_of_support.id}"

    redirect_to :funding_application_gp_project_evidence_of_support
  end

  private

  def project_params
    params.require(:project).permit(
      evidence_of_support_attributes: [
        :description,
        :evidence_of_support_files
      ]
    )
  end
end
