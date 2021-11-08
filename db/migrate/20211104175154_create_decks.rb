class CreateDecks < ActiveRecord::Migration[6.1]
  def change
    create_table :decks do |t|
      t.string :title, null: false
      t.timestamps
    end
  end
end
