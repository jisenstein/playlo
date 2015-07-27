class FixAssociations < ActiveRecord::Migration
  def change
    remove_column :spotify_artists, :twitter_friends_id

    change_table :spotify_artists do |t|
      t.belongs_to :twitter_friend, index:true
    end

    remove_column :tracks, :spotify_artists_id

    change_table :tracks do |t|
      t.belongs_to :spotify_artist, index:true
    end
  end
end
