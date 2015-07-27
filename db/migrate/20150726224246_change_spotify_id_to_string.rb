class ChangeSpotifyIdToString < ActiveRecord::Migration
  def change
    change_column :spotify_artists, :spotify_id, :string
  end
end
