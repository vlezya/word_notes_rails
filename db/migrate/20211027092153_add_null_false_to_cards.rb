class AddNullFalseToCards < ActiveRecord::Migration[6.1]
  def self.up
    change_column_null :cards, :word, false
    change_column_null :cards, :translation, false
  end
  
  def self.down
    change_column_null :cards, :word, true
    change_column_null :cards, :translation, true
  end
end
