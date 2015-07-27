class AddIndexToVariousColumns < ActiveRecord::Migration
  def change
    remove_column :users, :twitter_handle 

    add_column :spotify_artists, :artist_image_url, :string

    add_index :twitter_friends, :twitter_id, :unique => true
    add_index :spotify_artists, :spotify_id, :unique => true
    add_index :tracks, :spotify_track_id, :unique => true
  end
end
