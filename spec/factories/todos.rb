FactoryGirl.define do
  factory :todo do
    title { Faker::Lorem.sentence }
    priority { Faker::Number.digit }
  end
end