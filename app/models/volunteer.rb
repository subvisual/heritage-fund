class Volunteer < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :project

  validates :description, presence: true
  validates :hours, numericality: {
      only_integer: true,
      greater_than: 0
  }
end
