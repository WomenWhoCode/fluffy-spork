class GroupStat < ActiveRecord::Base
  include Retrievable

  class << self
    def meetup_primary_key
      :group_id
    end
  end
end
