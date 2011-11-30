class AddActionToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :action, :string
  end
end
