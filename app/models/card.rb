class Card < ApplicationRecord
  # Associations
  has_and_belongs_to_many :decks
  
  # Field validations
  validates :word, presence: true
  validates :translation, presence: true
  validates :example, presence: true
end
