class NonCashContribution < ApplicationRecord
  belongs_to :project

  validates :description, presence: true
  validates :amount, numericality: {only_integer: true}
end
