module Project::ProjectVolunteersHelper
  def calculate_total(volunteers)
    volunteers.all.pluck(:hours).compact.reduce(:+)
  end
end
