class CreateKarmaGrants < ActiveRecord::Migration
  def change
    create_table :karma_grants do |t|
      t.integer :from_user
      t.integer :to_user
      t.integer :karma_points

      t.timestamps
    end
  end
end
