FactoryGirl.define do
  factory :watermark do
    transient do
      data_type ""
    end

    url { "https://api.meetup.com/#{data_type}/?key=sanitized" }
  end
end
