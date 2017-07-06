FactoryGirl.define do
  factory :rsvp_question, class: RSVPQuestion do
    event_id { Faker::Lorem.characters(12) }
    group_urlname "Women-Who-Code-Silicon-Valley"
  end
end
