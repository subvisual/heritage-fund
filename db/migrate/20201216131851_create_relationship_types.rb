class CreateRelationshipTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :relationship_types, id: :integer do |t|
      t.text :name
      t.timestamps
    end
  end
end
