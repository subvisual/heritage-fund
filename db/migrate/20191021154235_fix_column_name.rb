class FixColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :released_forms, :type, :form_type 
  end
end
