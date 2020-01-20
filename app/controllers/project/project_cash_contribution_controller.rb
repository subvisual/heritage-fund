class Project::ProjectCashContributionController < ApplicationController
  include ProjectContext

  # This method is used to control navigational flow after a user
  # has submitted the 'Are you getting any cash contributions?' form
  def question_update

    logger.debug "Updating cash contributions question for project ID: #{@project.id}"

    @project.validate_cash_contributions_question = true

    @project.update(question_params)

    if @project.valid?

      logger.debug "Finished updating cash contributions question for project ID: #{@project.id}"

      if @project.cash_contributions_question == "true"

        redirect_to three_to_ten_k_project_project_cash_contribution_path

      else

        redirect_to three_to_ten_k_project_non_cash_contributions_get_path

      end

    else

      logger.debug "Validation failed for cash contributions question for project ID: #{@project.id}"

      render :question

    end

  end

  def project_cash_contribution
    @cash_contribution = @project.cash_contributions.build
  end


  def put
    # TODO: Validate fields
    @project.update(project_params)
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
