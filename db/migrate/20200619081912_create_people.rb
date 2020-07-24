class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people, id: :uuid do |t|
      t.string    :name
      t.date      :date_of_birth
      t.string    :email
      t.string    :position
      t.string    :phone_number

      t.timestamps
    end
  end
end
