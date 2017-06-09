FactoryGirl.define do
  factory :group_stat do
    group_id { Faker::Number.number(6) }
  end
end
