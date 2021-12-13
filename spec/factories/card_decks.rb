FactoryBot.define do
  factory :card_deck do
    card_id { Faker::Number.non_zero_digit }
    deck_id { Faker::Number.non_zero_digit }
  end
end
