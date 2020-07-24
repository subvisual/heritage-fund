class CreateFundingApplicationsPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :funding_applications_people, id: :uuid do |t|
      t.references  :person, type: :uuid, null: false, foreign_key: true 
      t.references  :funding_application, type: :uuid, null: false, foreign_key: true 
      t.timestamps
    end
  end
end
