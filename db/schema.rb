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

ActiveRecord::Schema.define(version: 20150726075433) do

  create_table "playlists", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists_tracks", force: :cascade do |t|
    t.integer "track_id"
    t.integer "playlist_id"
  end

  add_index "playlists_tracks", ["playlist_id"], name: "index_playlists_tracks_on_playlist_id"
  add_index "playlists_tracks", ["track_id"], name: "index_playlists_tracks_on_track_id"

  create_table "spotify_artists", force: :cascade do |t|
    t.integer "twitter_friends_id"
    t.string  "artist_name"
    t.integer "spotify_id"
  end

  add_index "spotify_artists", ["twitter_friends_id"], name: "index_spotify_artists_on_twitter_friends_id"

  create_table "tracks", force: :cascade do |t|
    t.string  "artist"
    t.string  "title"
    t.integer "type"
    t.integer "spotify_artists_id"
  end

  add_index "tracks", ["spotify_artists_id"], name: "index_tracks_on_spotify_artists_id"

  create_table "twitter_friends", force: :cascade do |t|
    t.string   "handle"
    t.string   "name"
    t.boolean  "verified"
    t.string   "profile_image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_id"
  end

  create_table "twitter_friends_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "twitter_friend_id"
  end

  add_index "twitter_friends_users", ["twitter_friend_id"], name: "index_twitter_friends_users_on_twitter_friend_id"
  add_index "twitter_friends_users", ["user_id"], name: "index_twitter_friends_users_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "slug"
    t.string   "twitter_handle"
    t.integer  "following_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["slug"], name: "index_users_on_slug", unique: true

end
