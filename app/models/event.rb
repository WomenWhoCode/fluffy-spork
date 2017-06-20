class Event < ActiveRecord::Base
  include Retrievable

  belongs_to :group, class_name: "GroupStat", primary_key: :group_id

  class << self
    def meetup_primary_key
      :event_id
    end

    def retrieve_events(group_stat)
      begin
        last_stored_time = group_stat.last_stored_event_time

        if last_stored_time
          since_time = I18n.l last_stored_time, format: :meetup_scroll_since
          options = { scroll: "since:#{since_time}" }
          m = Meetup::Api.new(data_type: [group_stat.urlname, "events"],
                              options: options)
        else
          m = Meetup::Api.new(data_type: [group_stat.urlname, "events"])
        end

        data = m.get_response
        while data && data.any?
          most_recent_event_time = data.map{|hash| hash["time"]}.max
          Event.insert_records(data)
          data = m.get_next_page(Date.today)
        end
        group_stat.update(last_stored_event_time: DateTime.strptime(most_recent_event_time.to_s, '%Q')) if most_recent_event_time

      rescue Exception => e
        Bugsnag.notify(e, group_id: group_stat.id)
      end
    end
  end
end
