class CreatePreApplicationsPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :pre_applications_people, id: :uuid do |t|
      t.references  :person, type: :uuid, null: false, foreign_key: true 
      t.references  :pre_application, type: :uuid, null: false, foreign_key: true 
      t.references  :relationship_types, type: :integer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
