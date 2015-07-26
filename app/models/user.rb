class User < ActiveRecord::Base
  has_and_belongs_to_many :twitter_friends
  has_many :playlists
end
