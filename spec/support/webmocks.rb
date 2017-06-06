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
end
