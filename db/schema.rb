# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170610003929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "event_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_stats", force: :cascade do |t|
    t.integer "group_id"
    t.string "name"
    t.text "description"
    t.float "lat"
    t.float "lon"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "urlname"
    t.integer "member_count", default: 0
    t.float "average_age"
    t.datetime "founded_date"
    t.datetime "pro_join_date"
    t.datetime "last_event"
    t.datetime "next_event"
    t.integer "past_events", default: 0
    t.integer "upcoming_events", default: 0
    t.integer "past_rsvps", default: 0
    t.float "rsvps_per_event", default: 0.0
    t.integer "repeat_rsvpers", default: 0
    t.float "gender_unknown", default: 0.0
    t.float "gender_female", default: 0.0
    t.float "gender_male", default: 0.0
    t.float "gender_other", default: 0.0
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "watermarks", force: :cascade do |t|
    t.string "url"
    t.string "etag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
