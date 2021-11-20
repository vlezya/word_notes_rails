class AddUserIdToDecks < ActiveRecord::Migration[6.1]
  def change
    add_column :decks, :user_id, :bigint, null: false
    add_index :decks, :user_id
  end
end
