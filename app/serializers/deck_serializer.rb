class DeckSerializer < ActiveModel::Serializer
  attributes :id, :title, :cards
  has_many :cards
end
