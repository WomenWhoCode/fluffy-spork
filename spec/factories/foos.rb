FactoryGirl.define do
  factory :foo do
    name { Faker::Name.name }
    title { Faker::HarryPotter.character }
  end
end
