class Project < ApplicationRecord
    belongs_to :user
    has_many :released_forms
end
