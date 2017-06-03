module Webmocks
  def meetup_request_success_stub(remaining: 29, reset: 10)
    stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
    .to_return(body: response.to_json, status: 200,
               headers: {"X-Ratelimit-Remaining"=>"#{remaining}",
                         "X-Ratelimit-Reset"=>"#{reset}"})
  end
end
