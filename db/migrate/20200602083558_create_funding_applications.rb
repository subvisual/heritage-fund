class CreateFundingApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :funding_applications, id: :uuid do |t|
      t.boolean :declaration
      t.text :declaration_description
      t.boolean :declaration_keep_informed
      t.boolean :declaration_user_research
      t.string :project_reference_number
      t.string :salesforce_case_id
      t.string :salesforce_case_number
      t.datetime :submitted_on
      t.references :organisation, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
