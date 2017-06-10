RSpec.describe Event, type: :model do
  describe ".insert_records" do
    let(:data) {
      [
        {
          "created"=>1494405694000,
          "duration"=>7200000,
          "id"=>"cqcpbnywjbqb",
          "name"=>"Cracking Code - (remote/online) Study Group",
          "status"=>"upcoming",
          "time"=>1497319200000,
          "updated"=>1496640174000,
          "utc_offset"=>-25200000,
          "waitlist_count"=>0,
          "yes_rsvp_count"=>31,
          "group"=> {
            "created"=>1399992406000,
            "name"=>"Women Who Code Silicon Valley",
            "id"=>14429832,
            "join_mode"=>"open",
            "lat"=>37.400001525878906,
            "lon"=>-122.01000213623047,
            "urlname"=>"Women-Who-Code-Silicon-Valley",
            "who"=>"Coders",
            "localized_location"=>"Sunnyvale, CA",
            "region"=>"en_US"
          },
          "link"=>"https://www.meetup.com/Women-Who-Code-Silicon-Valley/events/239890721/",
          "description"=>"a"*1000,
          "how_to_find_us"=>"Remote meeting (no physical location) - must email wwc.cracking.code@gmail.com",
          "visibility"=>"public"
        }
      ]
    }

    it "increases event records" do
      expect {
        Event.insert_records(data)
      }.to change(Event, :count).by(1)
    end

    it "sets fields correctly" do
      Event.insert_records(data)
      event = Event.last
      expect(event.event_id).to eq "cqcpbnywjbqb"
      expect(event.group_id).to eq 14429832
    end

    it "does not increase event record if event id already exists" do
      create(:event, event_id: data[0]["id"])
      expect {
        Event.insert_records(data)
      }.to_not change(Event, :count)
    end

    it "updates event record if event id already exists" do
      event = create(:event, event_id: data[0]["id"], group_id: 1)
      Event.insert_records(data)
      event.reload
      expect(event.group_id).to eq 14429832
    end
  end
end
