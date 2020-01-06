class AddProjectRefToVolunteers < ActiveRecord::Migration[6.0]
  def change
    add_reference :volunteers, :project, type: :uuid, null: false, foreign_key: true
  end
end
