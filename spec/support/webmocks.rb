module Webmocks
  def meetup_request_success_stub(remaining: 29, reset: 10)
    stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
    .to_return(body: response.to_json, status: 200,
               headers: {"Etag" => "abc",
                         "X-Ratelimit-Remaining"=>"#{remaining}",
                         "X-Ratelimit-Reset"=>"#{reset}"})
  end

  def meetup_request_not_modified_stub
    stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
    .to_return(status: 304)
  end

  def meetup_request_link_stub(remaining: 29, reset: 10)
    stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
    .to_return(body: response.to_json, status: 200,
               headers: {"Etag" => "abc",
                         "X-Ratelimit-Remaining"=>"#{remaining}",
                         "X-Ratelimit-Reset"=>"#{reset}",
                         "Link" => %Q|<https://api.meetup.com/some-url/events?key=abcde&scroll=since%3A2017-06-01T06%3A00%3A00.000-07%3A00>; rel="next"|}).then
    .to_return(body: response.to_json, status: 200,
               headers: {"Etag" => "abc",
                         "X-Ratelimit-Remaining"=>"#{remaining}",
                         "X-Ratelimit-Reset"=>"#{reset}",
                         "Link" => "<https://api.meetup.com/some-url/events?key=abcde&scroll=since%3A2018-06-01T06%3A00%3A00.000-07%3A00>; rel='next'"}).then
    .to_return(body: response.to_json, status: 200,
               headers: {"Etag" => "abc",
                         "X-Ratelimit-Remaining"=>"#{remaining}",
                         "X-Ratelimit-Reset"=>"#{reset}"})
  end
end
