class SessionSerializer < ActiveModel::Serializer
  attributes :id, :token, :user_id
end
