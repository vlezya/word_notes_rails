class CardDeckSerializer < ActiveModel::Serializer
  attributes :id, :card_id, :deck_id
end
