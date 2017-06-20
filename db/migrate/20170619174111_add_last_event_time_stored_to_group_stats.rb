class AddLastEventTimeStoredToGroupStats < ActiveRecord::Migration[5.1]
  def change
    add_column :group_stats, :last_stored_event_time, :timestamp
  end
end
