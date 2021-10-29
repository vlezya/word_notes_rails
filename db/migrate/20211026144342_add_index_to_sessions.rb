class AddIndexToSessions < ActiveRecord::Migration[6.1]
  def change
    add_index :sessions, :user_id
  end
end
