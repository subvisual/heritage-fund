class CreateLegalSignatories < ActiveRecord::Migration[6.0]
  def change
    create_table :legal_signatories, id: :uuid do |t|
      t.string :name
      t.string :email_address
      t.string :phone_number
      t.uuid :organisation_id

      t.index ["organisation_id"], name: "index_legal_signatories_on_organisation_id"
      t.timestamps
    end
  end
end
