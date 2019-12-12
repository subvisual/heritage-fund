class AddMissionToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :mission, :integer
  end
end
