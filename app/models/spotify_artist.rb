class SpotifyArtist < ActiveRecord::Base
  belongs_to :twitter_friend
  has_many :tracks
end
