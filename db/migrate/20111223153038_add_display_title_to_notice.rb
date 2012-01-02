class AddDisplayTitleToNotice < ActiveRecord::Migration
  def change
    add_column :notices, :display_title, :string
  end
end
