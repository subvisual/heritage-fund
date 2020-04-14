module Project::CalculateTotalHelper
  def calculate_total(object)
    object.select(:amount).map(&:amount).compact.sum
  end
end