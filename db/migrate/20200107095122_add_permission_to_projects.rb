class AddPermissionToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :permission_type, :integer
    add_column :projects, :permission_description, :text
  end
end
