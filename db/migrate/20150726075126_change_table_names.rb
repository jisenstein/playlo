class ChangeTableNames < ActiveRecord::Migration
  def change
    drop_table :tracks_playlists

    create_table :playlists_tracks do |t|
      t.belongs_to :track, index:true
      t.belongs_to :playlist, index:true
    end
  end
end
