class CashContribution < ApplicationRecord
  include GenericValidator

  self.implicit_order_column = "created_at"
  belongs_to :project
  has_many_attached :cash_contribution_evidence_files

  validates :description, presence: true
  validates :amount, numericality: { only_integer: true }
  validates_inclusion_of :secured, in: ["yes_with_evidence", "no", "x_not_sure", "yes_no_evidence_yet"]

  validate do

    validate_file_attached(
        :cash_contribution_evidence_files,
        "Add supporting evidence for a secured cash contribution with evidence"
    ) if self[:secured] == "yes_with_evidence"

    validate_length(
        :description,
        50,
        "Description of your cash contribution must be 50 words or fewer"
    )

  end

  enum secured: {
      yes_with_evidence: 0,
      no: 1,
      # added x_ prefix to avoid conflict with auto generated negative scopes.
      x_not_sure: 2,
      yes_no_evidence_yet: 3
  }
end
