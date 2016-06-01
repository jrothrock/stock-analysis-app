class AddUserNameToUsers < ActiveRecord::Migration
  def change
  	remove_index :users, :user_name
    add_index :users, :user_name, unique: true
  end
end
