class Event < ActiveRecord::Base
  include Retrievable

  class << self
    def meetup_primary_key
      :event_id
    end
  end
end
