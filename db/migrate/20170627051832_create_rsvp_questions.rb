class CreateRsvpQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :rsvp_questions do |t|
      t.string :event_id
      t.integer :question_id
      t.string :question
      t.string :answer
      t.integer :member_id
      t.string :group_urlname

      t.timestamps null: false
    end
  end
end
