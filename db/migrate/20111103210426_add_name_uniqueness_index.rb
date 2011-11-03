class AddNameUniquenessIndex < ActiveRecord::Migration
  def up
    add_index :users, :name, :unique => true
  end

  def down
    remove_index :users, :email
  end
end
