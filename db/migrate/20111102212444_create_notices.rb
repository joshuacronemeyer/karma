class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :poster_id
      t.string :named_non_users
      t.timestamp :timestamp_completed
      t.boolean :open

      t.timestamps
    end
  end
end
