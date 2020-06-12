class Project::DeclarationController < ApplicationController
  include ProjectContext, ObjectErrorsLogger

  # This method updates the confirm_declaration attribute of a project,
  # triggering the ApplicationToSalesforceJob and redirecting to
  # :three_to_ten_k_project_application_submitted if successful and
  # re-rendering :show_confirm_declaration method if unsuccessful
  def update_confirm_declaration

    logger.info "Updating confirm_declaration for project ID: #{@project.id}"

    @project.validate_confirm_declaration = true

    @project.update(confirm_declaration_params)

    if @project.valid?

      logger.info "Finished updating confirm_declaration for project " \
                  "ID: #{@project.id}"

      logger.info "Triggering ApplicationToSalesforceJob for project " \
                  "ID: #{@project.id}"

      if Flipper.enabled?(:grant_programme_sff_small)
        ApplicationToSalesforceJob.perform_later(@project)
        redirect_to :three_to_ten_k_project_application_submitted
      else
        redirect_to :three_to_ten_k_project_confirm_declaration
      end

    else

      logger.info "Validation failed when attempting to update " \
                  "confirm_declaration for project ID: #{@project.id}"

      log_errors(@project)

      render :show_confirm_declaration

    end


  end

  # This method updates the declaration-related attributes of a project,
  # redirecting to :three_to_ten_k_project_confirm_declaration if successful and
  # re-rendering :show_declaration method if unsuccessful
  def update_declaration

    logger.info "Updating declaration attributes for project ID: #{@project.id}"

    @project.validate_is_partnership = true

    if params[:project].present?
      if params[:project][:is_partnership].present?
        @project.validate_partnership_details = true if
            params[:project][:is_partnership] == "true"
      end
    end

    @project.update(declaration_params)

    if @project.valid?

      logger.info "Finished updating declaration attributes for project ID: " \
                   "#{@project.id}"

      redirect_to :three_to_ten_k_project_confirm_declaration

    else

      logger.info "Validation failed when attempting to update declaration " \
                   "attributes for project ID: #{@project.id}"

      log_errors(@project)

      render :show_declaration

    end

  end

  private

  def confirm_declaration_params

    unless params[:project].present?
      params.merge!({project: {confirm_declaration: ""}})
    end

    params.require(:project).permit(
        :confirm_declaration,
        :user_research_declaration
    )

  end

  def declaration_params

    params.require(:project).permit(
        :declaration_reasons_description,
        :keep_informed_declaration,
        :is_partnership,
        :partnership_details
    )

  end

end
