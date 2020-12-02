class AbstractProjectAttributes < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :project_reference_number, :string
    remove_column :projects, :salesforce_case_id, :string
    remove_column :projects, :salesforce_case_number, :string
    remove_column :projects, :submitted_on, :datetime
    add_reference :projects, :funding_application, type: :uuid, null: true, foreign_key: true
  end
end
