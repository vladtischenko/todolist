FactoryGirl.define do
  factory :task do
    text { Faker::Lorem.sentence }
    complete false
    priority { Faker::Number.digit }
  end
end