class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :user_id
      t.string :doers
      t.timestamp :time_completed
      t.boolean :open
      t.string :content
      t.string :display_title
      t.boolean :self_doer
      t.integer :description_comment_id
      t.timestamp :due_date
      t.integer :completed_by_id
      t.timestamps
    end
  end
end
