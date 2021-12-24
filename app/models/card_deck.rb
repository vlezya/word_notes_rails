class CardDeck < ApplicationRecord
  # Associations
  belongs_to :card
  belongs_to :deck
  
  # Validations
  validates :deck_id, presence: true
  validates :card_id, presence: true
  validates_uniqueness_of :deck_id, scope: :card_id
end
