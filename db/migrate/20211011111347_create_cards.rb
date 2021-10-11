class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :word
      t.string :translation
      t.text :example

      t.timestamps
    end
  end
end
