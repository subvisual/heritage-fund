class Volunteer < ApplicationRecord
  belongs_to :project

  validates :description, presence: true
  validates :hours, numericality: {only_integer: true}
end
