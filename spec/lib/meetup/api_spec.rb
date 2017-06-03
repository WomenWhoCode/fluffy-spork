describe Meetup::Api do
  it 'fails without #options' do
    expect {
      Meetup::Api.new(data_type: [])
    }.to raise_error(ArgumentError)
  end

  it 'fails without #data_type' do
    expect {
      Meetup::Api.new(options: {cat: 'mouse'})
    }.to raise_error(ArgumentError)
  end

  context 'when building url' do
    let(:meetup_api) {
      Meetup::Api.new(
        data_type: ['test_endpoint'],
        options: {cat: 'mouse',  dog: ',3m'})
    }

    it 'sets #options as part of the query string' do
      expect(meetup_api.build_url).to include('cat=mouse')
    end

    it 'sets #data_type as part of the url' do
      expect(meetup_api.build_url).to include("/test_endpoint/")
    end

    it 'handles any url encoding' do
      expect(meetup_api.build_url).to include(ERB::Util.url_encode ',3m')
    end
  end

  context 'when getting response' do
    let(:response) do
      {
        "id"=>12345,
        "name"=>"Meetup Group Name",
        "link"=>"https://www.meetup.com/Meetup-Group-Name/",
      }
    end
    let(:meetup_api) { Meetup::Api.new(data_type: [], options: {}) }

    context "valid request" do
      before do
        stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
        .to_return(body: response.to_json, status: 200,
                   headers: {"X-Ratelimit-Remaining"=>"29",
                             "X-Ratelimit-Reset"=>"10"})
      end

      it 'returns hash' do
        expect(meetup_api.get_response).to eq response
      end

      it "sets remaining_requests and reset_seconds values" do
        meetup_api.get_response
        expect(meetup_api.remaining_requests).to eq 29
        expect(meetup_api.reset_seconds).to eq 10
      end

      it "series of requests calls sleep" do
        stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
        .to_return(body: response.to_json, status: 200,
                   headers: {"X-Ratelimit-Remaining"=>"0",
                             "X-Ratelimit-Reset"=>"10"})
        expect_any_instance_of(Meetup::Api).to receive(:sleep).with(10).once
        meetup_api.get_response
        stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
        .to_return(body: response.to_json, status: 200,
                   headers: {"X-Ratelimit-Remaining"=>"20",
                             "X-Ratelimit-Reset"=>"10"})
        meetup_api.get_response
        meetup_api.get_response
      end
    end

    context "invalid request" do
      it 'notifies Bugsnag on error' do
        stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
        .to_return(body: '{}', status: 404, headers: {})

        expect(Bugsnag).to receive(:notify).once
        expect(meetup_api.get_response).to include("errors")
      end
    end
  end

  context "#throttle_wait" do
    let(:meetup_api) { Meetup::Api.new(data_type: [], options: {}) }

    it "returns 0 if remaining requests is positive" do
      expect_any_instance_of(Meetup::Api).to_not receive(:sleep)
      meetup_api.remaining_requests = 5
      expect(meetup_api.throttle_wait).to eq 0
    end

    it "returns reset seconds if remaining requests is negative" do
      meetup_api.remaining_requests = 0
      meetup_api.reset_seconds = 10
      expect_any_instance_of(Meetup::Api).to receive(:sleep).with(meetup_api.reset_seconds)
      expect(meetup_api.throttle_wait).to eq meetup_api.reset_seconds
    end
  end
end
