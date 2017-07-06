class RSVPQuestion < ActiveRecord::Base
  include Retrievable

  belongs_to :event, class_name: "Event", primary_key: :event_id

  class << self
    def retrieve_answers(event, m)
        meetup_data = m.get_response
        while meetup_data.present?
          meetup_data.each do |data|
            RSVPQuestion.create_from_answers(data)
          end

          meetup_data = m.get_next_page(Date.today)
        end

      rescue => e
        Bugsnag.notify(e, event_id: event.id)
    end

    def create_from_answers(data)
      return nil if data["answers"].blank?

      fields = {
        event_id: data["event"]["id"],
        group_urlname: data["group"]["urlname"],
        member_id: data["member"]["id"],
      }

      data["answers"].each do |ans|
        next if ans["answer"].blank?
        ans.delete("updated")
        RSVPQuestion.find_or_create_by(fields.merge(ans))
      end
    end
  end
end
