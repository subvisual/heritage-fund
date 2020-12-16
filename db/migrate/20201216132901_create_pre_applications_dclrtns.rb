class CreatePreApplicationsDclrtns < ActiveRecord::Migration[6.0]
  def change
    create_table :pre_applications_dclrtns, id: :uuid do |t|
      t.references  :declaration, type: :uuid, null: false, foreign_key: true 
      t.references  :pre_application, type: :uuid, null: false, foreign_key: true 
      t.timestamps
    end
  end
end
