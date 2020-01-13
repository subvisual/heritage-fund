class Project::ProjectCheckAnswersController < ApplicationController

  include ProjectContext

  def project_check_answers

  end

  def save_continue
    redirect_to three_to_ten_k_project_confirm_declaration_get_path
  end

end
