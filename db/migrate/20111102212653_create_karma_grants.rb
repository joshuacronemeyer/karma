class CreateKarmaGrants < ActiveRecord::Migration
  def change
    create_table :karma_grants do |t|
      t.integer :user_id
      t.integer :notice_id
      t.integer :karma_points

      t.timestamps
    end
  end
end
