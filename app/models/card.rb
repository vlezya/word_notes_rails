class Card < ApplicationRecord
  # Field validations
  validates :word, presence: true
  validates :translation, presence: true
  validates :example, presence: true
end
