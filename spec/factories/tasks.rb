FactoryGirl.define do
  factory :task do
    text { Faker::Lorem.sentence }
    complete false
    priority { 1 }
  end
end