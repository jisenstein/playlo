class SetDefaultPlaylistValueZero < ActiveRecord::Migration
  def change
    change_column :playlists, :artists_parsed, :integer, :default => 0
  end
end
