class CreatePaExpressionsOfInterest < ActiveRecord::Migration[6.0]
  def change
    create_table :pa_expressions_of_interest, id: :uuid do |t|
      t.references  :pre_application, type: :uuid, null: false, foreign_key: true 
      t.text :heritage_focus
      t.text :what_project_does
      t.text :programme_outcomes
      t.text :project_reasons
      t.text :feasability_or_options_work
      t.text :project_timescales
      t.text :overall_cost
      t.integer :potential_funding_amount
      t.text :likely_submission_description
      t.timestamps
    end
  end
end
