class AddUserIdToCards < ActiveRecord::Migration[6.1]
  def change
    add_column :cards, :user_id, :bigint, null: false
    add_index :cards, :user_id
  end
end
