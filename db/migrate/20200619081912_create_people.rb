class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people, id: :uuid do |t|
      t.string    :name
      t.date      :date_of_birth
      t.string    :email
      t.string    :phone_number
    end
  end
end
