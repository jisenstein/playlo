class CreatePlaylistTable < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :artists_parsed
      t.integer :total_artists
      t.timestamps
    end
  end
end
