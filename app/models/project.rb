class Project < ApplicationRecord
    belongs_to :user
    has_many :released_forms
    has_many_attached :evidence_of_support_files
end
