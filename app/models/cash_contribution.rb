class CashContribution < ApplicationRecord
  belongs_to :project
  has_many_attached :cash_contribution_evidence_files
  enum secured: {
      yes_with_evidence: 0,
      no: 1,
      # added x_ prefix to avoid conflict with auto generated negative scopes.
      x_not_sure: 2,
      yes_no_evidence_yet: 3
  }
end
