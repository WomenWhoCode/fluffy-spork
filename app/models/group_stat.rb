class GroupStat < ActiveRecord::Base
  include Retrievable

  has_many :events, primary_key: :group_id, foreign_key: :group_id

  class << self
    def meetup_primary_key
      :group_id
    end
  end

  def get_last_event_time_option
    last_event_time = events.order(time: :desc).first.try(:time)

    if last_event_time
      since_time = I18n.l last_event_time, format: :meetup_scroll_since
      options = { scroll: "since:#{since_time}" }
    else
      {}
    end
  end
end
