class SessionsController < ActionController::Base
  def twitter
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    session[:twitter_signed_in] = true

    @followings = Rails.cache.fetch(session['access_token'], :expires_in => 10.minutes) do
      puts "about to get client"
      twitter_client = client
      puts "just got client about to get friends"
      friends_list = JSON.parse(twitter_client.friends.to_json)
      puts "just got #{friends_list.count} friends let's do this"
      res = []
      friends_list.each do |friend|
        if friend["verified"] && !friend["name"].empty?
          res << friend["name"] 
        end
      end
      puts "found #{res.count} verified friends"
      res
    end
    redirect_to root_path
  end

  def spotify
    session[:spotify_credentials] = request.env['omniauth.auth']
    session[:spotify_signed_in] = true
    puts "logged into spotify"
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end
  
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.access_token = session['access_token']
      config.access_token_secret = session['access_token_secret']
    end
  end

end
