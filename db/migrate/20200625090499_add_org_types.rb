class AddOrgTypes < ActiveRecord::Migration[6.0]
  def up
    execute "insert into org_types (name, created_at, updated_at) values ('Registered charity', now(), now());"
    execute "insert into org_types (name, created_at, updated_at) values ('Registered company', now(), now());"
    execute "insert into org_types (name, created_at, updated_at) values ('Community Interest company', now(), now());"
    execute "insert into org_types (name, created_at, updated_at) values ('Faith-based organisation', now(), now());"
    execute "insert into org_types (name, created_at, updated_at) values ('Church organisation', now(), now());"
    execute "insert into org_types (name, created_at, updated_at) values ('Community group', now(), now());"
    execute "insert into org_types (name, created_at, updated_at) values ('Voluntary group', now(), now());"
    execute "insert into org_types (name, created_at, updated_at) values ('Individual private owner of heritage', now(), now());"
  end

  def down
    execute "delete from org_types where name = 'Registered charity';"
    execute "delete from org_types where name = 'Registered company';"
    execute "delete from org_types where name = 'Community Interest company';"
    execute "delete from org_types where name = 'Faith-based organisation';"
    execute "delete from org_types where name = 'Church organisation';"
    execute "delete from org_types where name = 'Community group';"
    execute "delete from org_types where name = 'Voluntary group';"
    execute "delete from org_types where name = 'Individual private owner of heritage';"
  end
end
