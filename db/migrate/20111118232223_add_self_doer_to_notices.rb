class AddSelfDoerToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :self_doer, :boolean
  end
end
