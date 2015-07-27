class TwitterFriend < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_one :spotify_artist

  def self.create_new(friend)
    TwitterFriend.create(handle: friend["screen_name"],
                         name: friend["name"],
                         verified: friend["verified"],
                         profile_image_url: friend["profile_image_url"],
                         twitter_id: friend["id"])
  end

  def find_spotify_artist
    artists = RSpotify::Artist.search(self.name, limit: 5)
    if artists.present? and artist[0].popularity > 20
      self.spotify_artist = SpotifyArtist.create_new(artists[0])
    end
  end
end
