class CreateReleasedForms < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
    ALTER TYPE form_type ADD VALUE 'permission-to-start';
    ALTER TYPE form_type ADD VALUE 'completion-report';
  SQL
    create_table :released_forms, id: :uuid do |t|
      t.references :projects
      t.column :type, :form_type
      t.timestamps
      t.jsonb 'payload'
    end
  end

  def down
    drop_table :released_forms
    execute <<-SQL
      DROP TYPE article_status;
    SQL
  end
end
