class RemoveArtistFromTracks < ActiveRecord::Migration
  def change
    remove_column :tracks, :artist
  end
end
