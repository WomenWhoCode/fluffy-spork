class Event < ActiveRecord::Base
  include Retrievable

  belongs_to :group, class_name: "GroupStat", primary_key: :group_id
  has_many :rsvp_questions,
    class_name: "RSVPQuestion",
    primary_key: :event_id,
    foreign_key: :event_id

  scope :without_rsvp, -> { includes(:rsvp_questions).where(rsvp_questions: {id: nil}) }

  class << self
    def meetup_primary_key
      :event_id
    end

    def retrieve_events(group_stat, m)
        data = m.get_response
        while data.present?
          Event.insert_records(data)
          data = m.get_next_page(Date.today)
        end

      rescue => e
        Bugsnag.notify(e, group_id: group_stat.id)
    end
  end
end
