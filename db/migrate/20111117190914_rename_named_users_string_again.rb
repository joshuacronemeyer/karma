class RenameNamedUsersStringAgain < ActiveRecord::Migration
  def up
    rename_column :notices, :other_people, :doers
  end

  def down
  end
end
