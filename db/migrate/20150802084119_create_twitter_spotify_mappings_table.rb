class CreateTwitterSpotifyMappingsTable < ActiveRecord::Migration
  def change
    create_table :twitter_spotify_mappings do |t|
      t.integer :twitter_id
      t.string :spotify_artist_id
      t.string :twitter_name
      t.string :spotify_name
      t.string :top_track_id
      t.boolean :is_correct_match, default: true
      t.timestamps
    end

    add_index :twitter_spotify_mappings, :twitter_id, :unique => true
    add_index :twitter_spotify_mappings, :spotify_artist_id
  end
end
