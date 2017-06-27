class RSVPQuestion < ActiveRecord::Base
  include Retrievable

  belongs_to :event, class_name: "Event", primary_key: :event_id

  class << self
    def retrieve_answers(event)
        m = Meetup::Api.new(
              data_type: [event.group_urlname, "events", event.event_id, "rsvps"],
              options: {fields: "answers"}
            )

        meetup_data = m.get_response
        while meetup_data && meetup_data.any?
          meetup_data.each do |data|
            RSVPQuestion.create_from_answers(data)
          end

          meetup_data = m.get_next_page(Date.today)
        end

      rescue => e
        Bugsnag.notify(e, event_id: event.id)
    end

    def create_from_answers(data)
      return nil unless data["answers"] && data["answers"].any?

      fields = {
        event_id: data["event"]["id"],
        group_urlname: data["group"]["urlname"],
        member_id: data["member"]["id"],
      }

      data["answers"].each do |ans|
        ans.delete("updated")
        RSVPQuestion.find_or_create_by(fields.merge(ans))
      end
    end
  end
end
