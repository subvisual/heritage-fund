class Project::ProjectCashContributionController < ApplicationController
  def project_cash_contribution
  end

  def cash_contribution_question
  end

  def save_cash_contribution

    cash_contributions = params['cash-contributions'].to_s == 'yes' ? true : false unless params['cash-contributions'].nil?

    # TODO really save cash_contributions data

    if (cash_contributions == true)
      redirect_to '/project/cash-contribution'
    else
      redirect_to '/grant/request'
    end
  end
end
