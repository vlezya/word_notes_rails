class CardDeck < ApplicationRecord
  # Associations
  belongs_to :card
  belongs_to :deck
  
  # Validations
  validates_uniqueness_of :deck_id, scope: :card_id
end
