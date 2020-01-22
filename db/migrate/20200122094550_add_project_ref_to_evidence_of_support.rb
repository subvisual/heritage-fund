class AddProjectRefToEvidenceOfSupport < ActiveRecord::Migration[6.0]
  def change
    add_reference :evidence_of_support, :project, type: :uuid, null: false, foreign_key: true
  end
end
