class AddMissionToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :mission, :string, array: true, default: []
  end
end