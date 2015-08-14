# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150813081021) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "playlists", force: :cascade do |t|
    t.integer  "artists_parsed", default: 0
    t.integer  "total_artists"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "twitter_spotify_mappings", force: :cascade do |t|
    t.string   "spotify_artist_id"
    t.string   "twitter_name"
    t.string   "spotify_name"
    t.string   "top_track_id"
    t.boolean  "is_correct_match",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_id",        limit: 8
  end

  add_index "twitter_spotify_mappings", ["spotify_artist_id"], name: "index_twitter_spotify_mappings_on_spotify_artist_id"
  add_index "twitter_spotify_mappings", ["twitter_id"], name: "index_twitter_spotify_mappings_on_twitter_id", unique: true

end
