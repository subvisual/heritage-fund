module Project::ProjectCostsHelper
  def calculate_total(project_costs)
    project_costs.select(:amount).map(&:amount).compact.reduce(:+)
  end
end
