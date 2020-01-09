module Project::ProjectVolunteersHelper
  def calculate_volunteer_total(volunteers)
    volunteers.all.pluck(:hours).compact.reduce(:+)
  end
end
