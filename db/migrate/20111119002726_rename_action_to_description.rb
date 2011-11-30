class RenameActionToDescription < ActiveRecord::Migration
  def up
    rename_column :notices, :action, :description
    
  end

  def down
  end
end
