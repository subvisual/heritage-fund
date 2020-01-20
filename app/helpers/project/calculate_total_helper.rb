module Project::CalculateTotalHelper
  def calculate_total(object)
    object.select(:amount).map(&:amount).compact.reduce(:+)
  end
end