class Volunteer < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :project
end
