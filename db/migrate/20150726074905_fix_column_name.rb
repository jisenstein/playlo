class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :tracks_playlists, :tracks_id, :track_id
    rename_column :tracks_playlists, :playlists_id, :playlist_id
  end
end
