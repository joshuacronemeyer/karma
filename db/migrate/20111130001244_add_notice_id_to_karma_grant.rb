class AddNoticeIdToKarmaGrant < ActiveRecord::Migration
  def change
    add_column :karma_grants, :notice_id, :integer
    rename_column :karma_grants, :from_user, :user_id
    remove_column :karma_grants, :to_user
  end
end
