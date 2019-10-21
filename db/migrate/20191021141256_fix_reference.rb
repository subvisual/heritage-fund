class FixReference < ActiveRecord::Migration[6.0]
  def change
    rename_column :released_forms, :projects_id, :project_id
  end
end
