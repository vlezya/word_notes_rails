class CreateCardsDecks < ActiveRecord::Migration[6.1]
  def change
    create_table :cards_decks, id: false do |t|
      t.bigint :card_id, null: false
      t.bigint :deck_id, null: false
      t.timestamps
      
      t.index [:card_id, :deck_id], unique: true
    end
  end
end
