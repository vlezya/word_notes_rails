class AddNullFalseToUsers < ActiveRecord::Migration[6.1]
  def self.up
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
  end
  
  def self.down
    change_column_null :users, :email, true
    change_column_null :users, :password_digest, true
  end
end
