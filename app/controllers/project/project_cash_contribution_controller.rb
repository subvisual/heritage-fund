class Project::ProjectCashContributionController < ApplicationController
  def project_cash_contribution
  end

  def cash_contribution_question
  end

  def save_cash_contribution_question

    cash_contributions = params['cash-contributions'].to_s == 'yes' ? true : false unless params['cash-contributions'].nil?

    # TODO really save cash_contributions data

    if (cash_contributions == true)
      redirect_to '/3-10k/project/cash-contribution'
    else
      redirect_to '/grant/request'
    end
  end

  def add_cash_contribution
    # TODO save cash_contribution
  end

  def process_cash_contributions
    # TODO process cash contributions
  end


end
