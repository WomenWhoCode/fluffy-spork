class AddLastEventTimeStoredToGroupStats < ActiveRecord::Migration[5.1]
  def change
    add_column :group_stats, :last_event_time_stored, :timestamp
  end
end
