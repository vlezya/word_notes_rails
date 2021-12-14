class Deck < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :card_decks, dependent: :destroy
  has_many :cards, through: :card_decks
  
  # Field validations
  validates :title, presence: true
end
