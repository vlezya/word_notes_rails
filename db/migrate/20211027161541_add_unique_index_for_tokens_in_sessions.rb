class AddUniqueIndexForTokensInSessions < ActiveRecord::Migration[6.1]
  def change
    add_index :sessions, :token, unique: true
  end
end
