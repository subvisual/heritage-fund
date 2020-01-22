class AddEvidenceOfSupport < ActiveRecord::Migration[6.0]
  def change

    create_table :evidence_of_support, id: :uuid do |t|
      t.string "description"
      t.timestamps
    end

    remove_column :projects, :evidence_description

  end
end
