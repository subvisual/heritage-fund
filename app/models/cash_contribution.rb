class CashContribution < ApplicationRecord
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

  def validate_file_attached(field, error_msg)
    unless self.public_send(field).attached?
      errors.add(field, error_msg)
    end
  end

  def validate_length(field, max_length, error_msg)

    word_count = self.public_send(field)&.split(' ')&.count

    logger.debug "#{field} word count is #{word_count}"

    if word_count && word_count > max_length
      self.errors.add(field, error_msg)
    end

  end

  enum secured: {
      yes_with_evidence: 0,
      no: 1,
      # added x_ prefix to avoid conflict with auto generated negative scopes.
      x_not_sure: 2,
      yes_no_evidence_yet: 3
  }
end
