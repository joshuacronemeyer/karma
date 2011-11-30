class RenameCommentsDescriptionToOriginalComment < ActiveRecord::Migration
  def up
     rename_column :comments, :description, :orignal_comment
   end

  def down
  end
end
