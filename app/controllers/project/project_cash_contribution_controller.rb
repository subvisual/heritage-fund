class Project::ProjectCashContributionController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method is used to control navigational flow after a user
  # has submitted the 'Are you getting any cash contributions?' form
  def question_update

    logger.info "Updating cash contributions question for project ID: #{@project.id}"

    @project.validate_cash_contributions_question = true

    @project.update(question_params)

    if @project.valid?

      logger.info "Finished updating cash contributions question for project ID: #{@project.id}"

      if @project.cash_contributions_question == "true"

        redirect_to three_to_ten_k_project_project_cash_contribution_path

      else

        redirect_to three_to_ten_k_project_grant_request_get_path

      end

    else

      logger.info "Validation failed for cash contributions question for project ID: #{@project.id}"

      log_errors(@project)

      render :question

    end

  end

  def put

    logger.info "Adding cash contribution for project ID: #{@project.id}"

    @project.validate_cash_contributions = true

    @project.update(project_params)

    if @project.valid?

      logger.info "Finished adding cash contribution for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_project_cash_contribution_path

    else

      logger.info "Validation failed when adding cash contribution for project ID: #{@project.id}"

      log_errors(@project)

      respond_to do |format|
        format.html {render :show}
        format.js {render :show}
      end

    end

  end

  def delete

    logger.info "User has selected to delete cash contribution ID: #{params[:cash_contribution_id]} from project ID: #{@project.id}"

    cash_contribution = CashContribution.find(params[:cash_contribution_id])

    logger.info "Deleting cash contribution ID: #{cash_contribution.id}"

    cash_contribution.destroy if cash_contribution.project_id == @project.id

    logger.info "Finished deleting cash contribution ID: #{cash_contribution.id}"

    redirect_to three_to_ten_k_project_project_cash_contribution_path

  end

  private
  def question_params
    if !params[:project].present?
      params.merge!({project: {cash_contributions_question: ""}})
    end
    params.require(:project).permit(:cash_contributions_question)
  end

  private
  def project_params
    params.require(:project).permit(cash_contributions_attributes: [:description, :secured, :amount, :cash_contribution_evidence_files])
  end


end
