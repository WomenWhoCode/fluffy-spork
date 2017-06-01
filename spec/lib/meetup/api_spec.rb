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

    it 'returns hash' do
      stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
        .to_return(body: response.to_json, status: 200, headers: {})

      expect(meetup_api.get_response).to eq response
    end

    it 'notifies Bugsnag on error' do
      stub_request(:get, Regexp.new(Meetup::Api::BASE_URI))
        .to_return(body: '{}', status: 404, headers: {})

      expect(Bugsnag).to receive(:notify).once
      expect(meetup_api.get_response).to include("errors")
    end
  end
end
