class RenameDescriptionInNoticesToContent < ActiveRecord::Migration
  def up
    rename_column :notices, :description, :content
  end

  def down
  end
end
