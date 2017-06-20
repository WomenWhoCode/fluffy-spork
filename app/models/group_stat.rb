class GroupStat < ActiveRecord::Base
  include Retrievable

  has_many :events, primary_key: :group_id, foreign_key: :group_id

  class << self
    def meetup_primary_key
      :group_id
    end
  end
end
