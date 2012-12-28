class CreateUserposts < ActiveRecord::Migration
  def change
    create_table :userposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # add an index attribute so that posts can be ordered
    add_index :userposts, [:user_id, :created_at]

  end
end
