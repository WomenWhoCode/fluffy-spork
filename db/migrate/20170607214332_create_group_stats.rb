class CreateGroupStats < ActiveRecord::Migration[5.1]
  def change
    create_table :group_stats do |t|
      t.integer :group_id
      t.string :name
      t.text :description
      t.float :lat
      t.float :lon
      t.string :city
      t.string :state
      t.string :country
      t.string :urlname
      t.integer :member_count, default: 0
      t.float :average_age
      t.timestamp :founded_date
      t.timestamp :pro_join_date
      t.timestamp :last_event
      t.timestamp :next_event
      t.integer :past_events, default: 0
      t.integer :upcoming_events, default: 0
      t.integer :past_rsvps, default: 0
      t.float :rsvps_per_event, default: 0
      t.integer :repeat_rsvpers, default: 0
      t.float :gender_unknown, default: 0
      t.float :gender_female, default: 0
      t.float :gender_male, default: 0
      t.float :gender_other, default: 0
      t.string :status

      t.timestamps null: false
    end
  end
end
