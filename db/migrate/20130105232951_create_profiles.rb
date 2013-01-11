class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :gender
      t.string :relationship_status
      t.date :birthdate
      t.string :city
      t.string :music
      t.string :about_me

      t.timestamps
    end
  end
end
