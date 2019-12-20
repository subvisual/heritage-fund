class Project::ProjectNonCashContributorsController < ApplicationController

  def non_cash_contributors_question
  end

  def save_non_cash_contributions_question

    non_cash_contributions = params['non-cash-contributions'].to_s == 'yes' ? true : false unless params['non-cash-contributions'].nil?

    # TODO really save non_cash_contributions data

    if (non_cash_contributions == true)
      redirect_to '/3-10k/project/non-cash-contribution'
    else
      redirect_to '/3-10k/project/cash-contribution-question'
    end

  end

  def non_cash_contribution
  end

  def add_non_cash_contribution
    # TODO save cash contribution
  end

  def process_non_cash
    # TODO process save and continue
  end

end
