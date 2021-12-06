class CardDeck < ApplicationRecord
  # Associations
  belongs_to :card
  belongs_to :deck
end
