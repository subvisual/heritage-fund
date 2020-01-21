class CashContribution < ApplicationRecord
  self.implicit_order_column = "created_at"
  belongs_to :project
  has_many_attached :cash_contribution_evidence_files

  validates :description, presence: true
  validates :amount, numericality: { only_integer: true }
  validates_inclusion_of :secured, in: ["yes_with_evidence", "no", "x_not_sure", "yes_no_evidence_yet"]

  # TODO: Validate inclusion of evidence files if
  #       :secured == "yes_with_evidence"

  enum secured: {
      yes_with_evidence: 0,
      no: 1,
      # added x_ prefix to avoid conflict with auto generated negative scopes.
      x_not_sure: 2,
      yes_no_evidence_yet: 3
  }
end
