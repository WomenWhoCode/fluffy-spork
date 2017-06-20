FactoryGirl.define do
  factory :group_stat do
    group_id { Faker::Number.number(6) }
    urlname "Women-Who-Code-Silicon-Valley"
  end
end
