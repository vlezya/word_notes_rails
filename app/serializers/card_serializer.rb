class CardSerializer < ActiveModel::Serializer
  attributes :id, :word, :translation, :example
end
