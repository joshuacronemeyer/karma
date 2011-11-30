class ConvertCommentsUserIdToNoticeId < ActiveRecord::Migration
  def up
        rename_column :comments, :user_id, :notice_id
  end

  def down
  end
end
