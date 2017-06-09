RSpec.describe GroupStat, type: :model do
  describe ".insert_records" do
    let(:data) {
      [
        {
          "id"=>21591264,
          "name"=>"Women Who Code Pune",
          "description"=> "a"*1000,
          "lat"=>18.53,
          "lon"=>73.83,
          "city"=>"Pune",
          "state"=>"some state",
          "country"=>"India",
          "urlname"=>"Women-Who-Code-Pune",
          "member_count"=>508,
          "average_age"=>27.23,
          "founded_date"=>1481835203000,
          "pro_join_date"=>1481835560000,
          "last_event"=>1496464200000,
          "next_event"=>1496465200000,
          "past_events"=>5,
          "upcoming_events"=>0,
          "past_rsvps"=>235,
          "rsvps_per_event"=>47.0,
          "repeat_rsvpers"=>53,
          "gender_unknown"=>0.0052,
          "gender_female"=>0.5598,
          "gender_male"=>0.4296,
          "gender_other"=>0.0052,
          "status"=>"Active",
          "topics"=>"not collecting but getting returned in response",
          "category"=>"not collecting but getting returned in response",
          "organizers"=>"not collecting but getting returned in response",
        }
      ]
    }

    it "increases group_stat records" do
      expect {
        GroupStat.insert_records(data)
      }.to change(GroupStat, :count).by(1)
    end

    it "sets fields correctly" do
      GroupStat.insert_records(data)
      group_stat = GroupStat.last
      expect(group_stat.group_id).to eq 21591264
      expect(group_stat.name).to eq "Women Who Code Pune"
      expect(group_stat.description).to eq "a"*1000
      expect(group_stat.lat).to eq 18.53
      expect(group_stat.lon).to eq 73.83
      expect(group_stat.city).to eq "Pune"
      expect(group_stat.state).to eq "some state"
      expect(group_stat.country).to eq "India"
      expect(group_stat.urlname).to eq "Women-Who-Code-Pune"
      expect(group_stat.member_count).to eq 508
      expect(group_stat.average_age).to eq 27.23
      expect(group_stat.founded_date).to eq Time.utc(2016,12,15,20,53,23)
      expect(group_stat.pro_join_date).to eq Time.utc(2016,12,15,20,59,20)
      expect(group_stat.last_event).to eq Time.utc(2017,6,3,4,30,0)
      expect(group_stat.next_event).to eq Time.utc(2017,6,3,4,46,40)
      expect(group_stat.past_events).to eq 5
      expect(group_stat.upcoming_events).to eq 0
      expect(group_stat.past_rsvps).to eq 235
      expect(group_stat.rsvps_per_event).to eq 47.0
      expect(group_stat.repeat_rsvpers).to eq 53
      expect(group_stat.gender_unknown).to eq 0.0052
      expect(group_stat.gender_female).to eq 0.5598
      expect(group_stat.gender_male).to eq 0.4296
      expect(group_stat.gender_other).to eq 0.0052
      expect(group_stat.status).to eq "Active"
    end

    it "does not increase group_stat record if group id already exists" do
      create(:group_stat, group_id: data[0]["id"])
      expect {
        GroupStat.insert_records(data)
      }.to_not change(GroupStat, :count)
    end

    it "updates group_stat record if group id already exists" do
      group_stat = create(:group_stat, group_id: data[0]["id"], past_events: 2)
      GroupStat.insert_records(data)
      group_stat.reload
      expect(group_stat.past_events).to eq 5
    end
  end
end
