FactoryGirl.define do
  factory :task do
    text { Faker::Lorem.sentence }
    complete false
    priority { 1 }
    file_for_task Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/support/ruby_motion.jpg')))
  end
end