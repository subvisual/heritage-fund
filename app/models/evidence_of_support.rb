class EvidenceOfSupport < ApplicationRecord
  include GenericValidator

  # This overrides Rails attempting to pluralise the model name
  self.table_name = "evidence_of_support"

  self.implicit_order_column = "created_at"

  belongs_to :project
  has_many_attached :evidence_of_support_files

  validates :description, presence: true

  validate do

    validate_file_attached(
        :evidence_of_support_files,
        "Add an evidence of support file"
    )

    validate_length(
        :description,
        50,
        "Description of your evidence of support must be 50 words or fewer"
    )

  end

end

