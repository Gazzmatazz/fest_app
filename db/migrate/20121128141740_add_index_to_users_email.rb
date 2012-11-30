class AddIndexToUsersEmail < ActiveRecord::Migration

# to enforce uniqueness at the database level. 
# add a database index on the email column, 
# and then require that the index be unique.

  def change
  	    add_index :users, :email, unique: true
  end

end

# This uses a Rails method called add_index to add an 
# index on the email column of the users table.
