class AddProjectToCashContributions < ActiveRecord::Migration[6.0]
  def change
    add_reference :cash_contributions, :project, type: :uuid, null: false, foreign_key: true
  end
end
