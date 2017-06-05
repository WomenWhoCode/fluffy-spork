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
        meetup_request_success_stub
      end

      it 'returns hash' do
        expect(meetup_api.get_response).to eq response
      end

      it "sets remaining_requests and reset_seconds values" do
        meetup_api.get_response
        expect(meetup_api.remaining_requests).to eq 29
        expect(meetup_api.reset_seconds).to eq 10
      end

      it "calls sleep after a series of requests" do
        expect_any_instance_of(Meetup::Api).to receive(:sleep).with(10).once
        meetup_request_success_stub(remaining: 0)
        # This call uses default initializing and won't call sleep.
        # Returns 0 requests remaining.
        meetup_api.get_response
        # This call should have the 0 requests remaining from the previous
        # request and will call the sleep function. After the api request, it
        # returns 20 requests remaining.
        meetup_request_success_stub(remaining: 20)
        meetup_api.get_response
        # Requests remaining will be set to 20 so sleep will not be called
        # for this request either.
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

    it "does not sleep if remaining requests is positive" do
      meetup_api.remaining_requests = 5
      expect_any_instance_of(Meetup::Api).to_not receive(:sleep)
      meetup_api.throttle_wait
    end

    it "returns reset seconds if remaining requests is negative" do
      meetup_api.remaining_requests = 0
      meetup_api.reset_seconds = 10
      expect_any_instance_of(Meetup::Api).to receive(:sleep).with(meetup_api.reset_seconds)
      meetup_api.throttle_wait
    end
  end
end
