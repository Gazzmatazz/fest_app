class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :music
      t.string :gender
      t.string :city

      t.timestamps
    end
  end
end
