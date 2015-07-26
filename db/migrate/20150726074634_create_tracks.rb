class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :artist
      t.string :title
      t.integer :type
    end

    create_table :tracks_playlists do |t|
      t.belongs_to :tracks, index:true
      t.belongs_to :playlists, index:true
    end
  end
end
