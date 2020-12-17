class RelationshipType < ApplicationRecord
    
    has_many :pre_applications_people, inverse_of: :relationship_type
    has_many :pre_applications, through: :pre_applications_people

end

# / views / pre_application / pa_project_enquiries / start / view.html.erb
# / controllers/ pre_application / pa_project_enquiries / start / start_controller.rb