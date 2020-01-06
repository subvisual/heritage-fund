class CreateVolunteers < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteers, id: :uuid do |t|
      t.text(:description)
      t.integer(:hours)
      t.timestamps
    end
  end
end
