class RenameNamedUsersString < ActiveRecord::Migration
  def up
    rename_column :notices, :named_non_users, :other_people
  end

  def down
    rename_column :notices, :other_people, :named_non_users     
  end
end
