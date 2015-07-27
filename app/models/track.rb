class Track < ActiveRecord::Base
  has_and_belongs_to_many :playlists
  belongs_to :spotify_artist

  def self.create_new(track)
    Track.create(spotify_track_id: track.id,
                 title: track.name)
  end
end
