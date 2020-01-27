class Project::ProjectNonCashContributionsController < ApplicationController
  include ProjectContext

  # This method is used to control navigational flow after a user
  # has submitted the 'Are you getting any non-cash contributions?' form
  def question_update

    logger.debug "Updating non-cash contributions question for project ID: #{@project.id}"

    @project.validate_non_cash_contributions_question = true

    @project.update(question_params)

    if @project.valid?

      logger.debug "Finished updating non-cash contributions question for project ID: #{@project.id}"

      if @project.non_cash_contributions_question == "true"

        redirect_to three_to_ten_k_project_non_cash_contributions_get_path

      else

        redirect_to three_to_ten_k_project_volunteers_path

      end

    else

      logger.debug "Validation failed for non-cash contributions question for project ID: #{@project.id}"

      render :question

    end

  end

  def update

    # Empty flash values to ensure that we don't redisplay them unnecessarily
    flash[:description] = ""
    flash[:amount] = ""

    logger.debug "Adding non-cash contribution for project ID: #{@project.id}"

    @project.validate_non_cash_contributions = true

    @project.update(project_params)

    if @project.valid?

      logger.debug "Successfully added non-cash contribution for project ID: #{@project.id}"

      redirect_to three_to_ten_k_project_non_cash_contributions_get_path

    else

      logger.debug "Validation failed when adding non-cash contribution for project ID: #{@project.id}"

      # Store flash values to display them again when re-rendering the page
      flash[:description] = params['project']['non_cash_contributions_attributes']['0']['description']
      flash[:amount] = params['project']['non_cash_contributions_attributes']['0']['amount']

      render :show

    end

  end

  def delete

    logger.debug "User has selected to delete non-cash contribution ID: #{params[:non_cash_contribution_id]}" \
                    " from project ID: #{@project.id}"

    non_cash_contribution = NonCashContribution.find(params[:non_cash_contribution_id])

    logger.debug "Deleting non-cash contribution ID: #{non_cash_contribution.id}"

    non_cash_contribution.destroy if non_cash_contribution.project_id == @project.id

    logger.debug "Finished deleting non-cash contribution ID: #{non_cash_contribution.id}"

    redirect_to three_to_ten_k_project_non_cash_contributions_get_path

  end

  private
  def question_params
    if !params[:project].present?
      params.merge!({project: {non_cash_contributions_question: ""}})
    end
    params.require(:project).permit(:non_cash_contributions_question)
  end

  private
  def project_params
    params.require(:project).permit(non_cash_contributions_attributes: [:description, :amount])
  end

end
