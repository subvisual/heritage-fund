class CreateDeclarations < ActiveRecord::Migration[6.0]
  def change
    create_table :declarations, id: :uuid do |t|
      t.string  :grant_programme
      t.string  :declaration_type
      t.jsonb   :json
      t.integer  :version
      t.timestamps   
    end
  end
end
