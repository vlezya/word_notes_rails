class Deck < ApplicationRecord
  # Associations
  has_and_belongs_to_many :cards, unique: true
  
  # Field validations
  validates :title, presence: true
end
