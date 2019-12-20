class Project::ProjectDeclarationController < ApplicationController

  def project_declaration
    # get
  end

  def confirm_declaration
    # get
  end

  def declaration_confirmed
    # TODO save the following data
    privacy_reasons = params['privacy-reasons']
    involve_me_in_research = params['involve-me-in-research'].nil? ? false : true
    keep_me_informed = params['keep-me-informed'].nil? ? false : true
    redirect_to '/3-10k/project/confirm-declaration'
  end

  def submit_application
    confirm_declaration = params['confirm-declaration'].nil? ? false : true
    # TODO save confirmation and process application
  end
end
