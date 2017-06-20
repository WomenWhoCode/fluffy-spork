class RemoveLastStoredEventTimeFromGroupStats < ActiveRecord::Migration[5.1]
  def change
    remove_column :group_stats, :last_stored_event_time, :timestamp
  end
end
