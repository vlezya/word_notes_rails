FactoryBot.define do
  factory :card do
    word { Faker::Lorem.word }
    translation { Faker::Lorem.word }
    example { Faker::Lorem.sentence }
  end
end
