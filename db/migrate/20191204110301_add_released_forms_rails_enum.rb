class AddReleasedFormsRailsEnum < ActiveRecord::Migration[6.0]
  def change
    add_column :released_forms, :form_type, :integer
  end
end
