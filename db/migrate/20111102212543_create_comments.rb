class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.boolean :description
      t.integer :poster_id
      t.string :comment

      t.timestamps
    end
  end
end
