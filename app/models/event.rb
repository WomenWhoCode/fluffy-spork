class Event < ActiveRecord::Base
  include Retrievable

  belongs_to :group, class_name: "GroupStat", primary_key: :group_id

  class << self
    def meetup_primary_key
      :event_id
    end

    def retrieve_events(group_stat)
      begin
        last_event_time = group_stat.events.order(time: :desc).first.try(:time)

        if last_event_time
          since_time = I18n.l last_event_time, format: :meetup_scroll_since
          options = { scroll: "since:#{since_time}" }
          m = Meetup::Api.new(data_type: [group_stat.urlname, "events"],
                              options: options)
        else
          m = Meetup::Api.new(data_type: [group_stat.urlname, "events"])
        end

        data = m.get_response
        while data && data.any?
          Event.insert_records(data)
          data = m.get_next_page(Date.today)
        end

      rescue Exception => e
        Bugsnag.notify(e, group_id: group_stat.id)
      end
    end
  end
end
