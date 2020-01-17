module Project::ProjectNonCashContributionsHelper
  def calculate_total(non_cash_contributions)
    non_cash_contributions.select(:amount).map(&:amount).compact.reduce(:+)
  end
end