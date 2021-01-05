class AddOutcomesToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :outcome_2, :boolean
    add_column :projects, :outcome_3, :boolean
    add_column :projects, :outcome_4, :boolean
    add_column :projects, :outcome_5, :boolean
    add_column :projects, :outcome_6, :boolean
    add_column :projects, :outcome_7, :boolean
    add_column :projects, :outcome_8, :boolean
    add_column :projects, :outcome_9, :boolean

    add_column :projects, :outcome_2_description, :text
    add_column :projects, :outcome_3_description, :text
    add_column :projects, :outcome_4_description, :text
    add_column :projects, :outcome_5_description, :text
    add_column :projects, :outcome_6_description, :text
    add_column :projects, :outcome_7_description, :text
    add_column :projects, :outcome_8_description, :text
    add_column :projects, :outcome_9_description, :text
  end
end
