class PreApplicationsPerson < ApplicationRecord
    belongs_to :pre_application
    belongs_to :person
    belongs_to :relationship_types
end
