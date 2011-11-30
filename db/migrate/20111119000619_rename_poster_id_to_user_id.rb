class RenamePosterIdToUserId < ActiveRecord::Migration
  def up
    rename_column :notices, :poster_id, :user_id
  end

  def down
  end
end
