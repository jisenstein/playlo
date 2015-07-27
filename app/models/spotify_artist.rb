class SpotifyArtist < ActiveRecord::Base
  belongs_to :twitter_friend
  has_many :tracks

  def self.create_new(artist)
    if (sa = SpotifyArtist.find_by_spotify_id(artist.id))
      sa
    else
      sa = SpotifyArtist.new(artist_name: artist.name,
                             spotify_id: artist.id,
                             artist_image_url: artist.images[0]["url"])
      top_tracks = artist.top_tracks(:US)
      if top_tracks.present?
        sa.tracks << Track.create_new(top_tracks[0])
      end
      sa.save
      sa
    end
  end
end
