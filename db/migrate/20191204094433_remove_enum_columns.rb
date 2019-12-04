class RemoveEnumColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :organisations, :type
    remove_column :released_forms, :form_type
  end
end
