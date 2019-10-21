class FixTypeOfReference < ActiveRecord::Migration[6.0]
  def change
    execute <<-SQL
    ALTER TABLE released_forms ALTER COLUMN projects_id SET DATA TYPE UUID USING (uuid_generate_v4());
    SQL
  end
end
