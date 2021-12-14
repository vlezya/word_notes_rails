class AddIdToCardDecks < ActiveRecord::Migration[6.1]
  def change
    add_column :card_decks, :id, :primary_key, first: true
  end
end
