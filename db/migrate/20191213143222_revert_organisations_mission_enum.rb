require_relative '20191212120428_add_mission_to_organisations'

class RevertOrganisationsMissionEnum < ActiveRecord::Migration[6.0]
  def change
    revert AddMissionToOrganisations
    add_column :organisations, :mission, :string, array: true, default: []
  end
end
