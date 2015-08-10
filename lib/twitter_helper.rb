module TwitterHelper
  def self.fetch_friends
    begin
      client = twitter_client
      verified_friend_names = []
      friends = client.friends({ count: 200, skip_status: true, include_user_entities: false })
      friends.each do |f|
        if f.verified?
          verified_friend_names << [f.name, f.id]
        end
      end
    rescue Twitter::Error::TooManyRequests => error
      puts "Hit rate limit, will reset in #{error.rate_limit.reset_in}."
      flash[:notice] = "Hit rate limit."
      raise
    end
    Rails.cache.write(session['access_token'], verified_friend_names, expires_in: 1.hour)
  end

  def self.twitter_client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.access_token = session['access_token']
      config.access_token_secret = session['access_token_secret']
    end
  end
end
