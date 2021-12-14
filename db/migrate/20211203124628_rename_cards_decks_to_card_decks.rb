class RenameCardsDecksToCardDecks < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :cards_decks, :card_decks
  end
  
  def self.down
    rename_table :card_decks, :cards_decks
  end
end
