class DestroyTables < ActiveRecord::Migration
  def change
    drop_table :users
    drop_table :twitter_friends
    drop_table :spotify_artists
    drop_table :tracks
    drop_table :playlists
  end
end
