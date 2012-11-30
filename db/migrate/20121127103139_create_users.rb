class CreateUsers < ActiveRecord::Migration

# 'change' method to determine changes to be made to database
# calls method 'create_table'
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end

end
