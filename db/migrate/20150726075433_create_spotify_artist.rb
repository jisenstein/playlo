class CreateSpotifyArtist < ActiveRecord::Migration
  def change
    create_table :spotify_artists do |t|
      t.belongs_to :twitter_friends, index:true
      t.string :artist_name
      t.integer :spotify_id
    end

    change_table :tracks do |t|
      t.belongs_to :spotify_artists, index:true
    end

    add_column :twitter_friends, :twitter_id, :integer

  end
end
