FactoryGirl.define do
  factory :event do
    event_id { Faker::Lorem.characters(12) }
  end
end
