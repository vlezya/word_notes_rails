class Card < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :card_decks, dependent: :destroy
  has_many :decks, through: :card_decks
  
  # Field validations
  validates :word, presence: true
  validates :translation, presence: true
  validates :example, presence: true
end
