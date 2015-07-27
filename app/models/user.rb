class User < ActiveRecord::Base
  has_and_belongs_to_many :twitter_friends
  has_many :playlists

  def self.create_new(slug, client)
    friends = JSON.parse(client.friends.to_json)
    user = User.new(slug: slug, following_count: friends.count)
    friends.each do |friend|
      if (tf = TwitterFriend.find_by_twitter_id(friend["twitter_id"]))
        user.twitter_friends << tf
      else
        tf = TwitterFriend.create_new(friend)
        tf.find_spotify_artist
        user.twitter_friends << tf 
      end
    end
    user.save
    user
  end
end
