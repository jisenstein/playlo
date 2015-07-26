class DropPlaylistsTable < ActiveRecord::Migration
  def down
    drop_table :playlists
  end
end
