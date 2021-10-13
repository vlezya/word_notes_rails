class Card < ApplicationRecord
  validates_presence_of :word, :translation, :example
end
