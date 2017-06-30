RSpec.describe RSVPQuestion, type: :model do
  it "has a valid factory" do
    rsvp_question = build(:rsvp_question)
    expect(rsvp_question.valid?).to be true
  end

  it "belongs to an event" do
    event = create(:event)
    rsvp_question = create(:rsvp_question, event_id: event.event_id)
    expect(rsvp_question.event).to eq event
  end

  let(:data) {
    [
      {
        "created" => 1497990769000,
        "updated" => 1497990769000,
        "response" => "yes",
        "guests" => 0,
        "event" =>
        {
          "id" => "dkxpgnywjbdc",
          "name" => "iOS Beginner Series: Intro to iOS & Swift",
          "yes_rsvp_count" => 71,
          "time" => 1498181400000,
          "utc_offset" => -25200000
        },
        "group" =>
        {
          "id" => 14429832,
          "urlname" => "Women-Who-Code-Silicon-Valley",
          "name" => "Women Who Code Silicon Valley",
          "who" => "Coders",
          "members" => 3858,
          "join_mode" => "open",
          "group_photo" =>
          {
            "id" => 431687379,
            "highres_link" => "https://secure.meetupstatic.com/photos/event/b/9/1/3/highres_431687379.jpeg",
            "photo_link" => "https://secure.meetupstatic.com/photos/event/b/9/1/3/600_431687379.jpeg",
            "thumb_link" => "https://secure.meetupstatic.com/photos/event/b/9/1/3/thumb_431687379.jpeg",
            "type" => "event",
            "base_url" => "https://secure.meetupstatic.com"
          }
        },
        "member" =>
        {
          "id" => Faker::Number.number(5),
          "name" => Faker::StarWars.character,
          "event_context" => {"host" => false}
        },
        "venue" =>
        {
          "id" => 24949344,
          "name" => "Coding Dojo",
          "lat" => 37.37540054321289,
          "lon" => -121.91015625,
          "repinned" => false,
          "address_1" => "1920 Zanker Rd #20",
          "city" => "San Jose",
          "country" => "us",
          "localized_country_name" => "USA",
          "zip" => "",
          "state" => "CA"
        },
        "answers" =>
        [
          {
            "answer" => Faker::StarWars.wookie_sentence,
            "question_id" => Faker::Number.number(5).to_i,
            "question" => Faker::StarWars.quote,
            "updated" => 1497990769000
          }
        ]
      }
    ]
  }

  describe ".create_from_answers" do
    it "increases rsvp_question records" do
      expect {
        RSVPQuestion.create_from_answers(data[0])
      }.to change(RSVPQuestion, :count).by(1)
    end

    it "sets fields correctly" do
      row = data[0]
      RSVPQuestion.create_from_answers(row)
      rsvp_question = RSVPQuestion.last
      expect(rsvp_question.event_id).to eq row["event"]["id"]
      expect(rsvp_question.group_urlname).to eq row["group"]["urlname"]
      expect(rsvp_question.question).to eq row["answers"][0]["question"]
      expect(rsvp_question.question_id).to eq row["answers"][0]["question_id"]
      expect(rsvp_question.answer).to eq row["answers"][0]["answer"]
    end

    it "does not increase rsvp_question record if it already exists" do
      RSVPQuestion.create_from_answers(data[0])
      expect {
        RSVPQuestion.create_from_answers(data[0])
      }.to_not change(RSVPQuestion, :count)
    end

    it "skips rsvp_question record if answer is not included in response" do
      row = data[0]
      row.delete("answers")
      expect {
        RSVPQuestion.create_from_answers(row)
      }.to_not change(RSVPQuestion, :count)
    end

    it "skips rsvp_question record if answer provided is blank" do
      row = data[0]
      row["answers"][0]["answer"] = ""
      expect {
        RSVPQuestion.create_from_answers(row)
      }.to_not change(RSVPQuestion, :count)
    end
  end

  describe ".retrieve_answers" do
    let(:response) { data }
    before do
      meetup_request_success_stub
    end

    it "increases rsvp_question records" do
      expect {
        RSVPQuestion.retrieve_answers(build(:event))
      }.to change(RSVPQuestion, :count).by(1)
    end
  end
end
