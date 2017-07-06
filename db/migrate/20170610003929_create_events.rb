class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event_id
      t.integer :group_id

      t.timestamps null: false
    end
  end
end
