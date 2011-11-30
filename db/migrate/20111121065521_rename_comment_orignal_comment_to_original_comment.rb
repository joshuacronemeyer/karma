class RenameCommentOrignalCommentToOriginalComment < ActiveRecord::Migration
  def up
    rename_column :comments, :orignal_comment, :original_comment

  end

  def down
  end
end
