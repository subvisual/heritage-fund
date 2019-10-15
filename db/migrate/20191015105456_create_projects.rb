class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.references :users
      t.string :project_title
      t.timestamps
    end
  end
end
