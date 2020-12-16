class CreatePreApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :pre_applications, id: :uuid do |t|
      t.references  :organisation, type: :uuid, null: false, foreign_key: true
      t.references  :heard_about_types, type: :integer, null: false, foreign_key: true
      t.text :project_reference_number
      t.text :salesforce_case_id
      t.text :salesforce_case_number
      t.text :submitted_on
      t.text :heard_about_ff
      t.timestamps
    end
  end
end
