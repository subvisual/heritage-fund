class AddEvidenceDescriptionToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :evidence_description, :string, array: true, default: []
  end
end
