class MakeTwitterIdBigger < ActiveRecord::Migration
  def change
    remove_column :twitter_spotify_mappings, :twitter_id
    add_column :twitter_spotify_mappings, :twitter_id, :integer, limit: 8
    add_index :twitter_spotify_mappings, :twitter_id, unique: true
  end
end
