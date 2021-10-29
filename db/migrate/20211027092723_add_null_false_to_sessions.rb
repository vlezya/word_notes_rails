class AddNullFalseToSessions < ActiveRecord::Migration[6.1]
  def self.up
    change_column_null :sessions, :token, false
    change_column_null :sessions, :user_id, false
  end
  
  def self.down
    change_column_null :sessions, :token, true
    change_column_null :sessions, :user_id, true
  end
end
