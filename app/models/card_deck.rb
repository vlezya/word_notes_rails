class CardDeck < ApplicationRecord
  # Associations
  belongs_to :card
  belongs_to :deck
  
  # Validations
  validates_presence_of :deck_id
  validates_presence_of :card_id
  validates_uniqueness_of :deck_id, scope: :card_id
end
