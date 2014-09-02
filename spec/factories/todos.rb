FactoryGirl.define do
  factory :todo do
    title { Faker::Lorem.sentence }
    priority { 1 }
  end
end