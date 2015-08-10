class SessionsController < ApplicationController
  def twitter
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    begin
      fetch_twitter_friends
      session[:twitter_signed_in] = true
      redirect_to root_path
    rescue
      flash[:notice] = "Error logging into Twitter, please try again later."
      redirect_to root_path
    end
  end

  def spotify
    session[:spotify_credentials] = request.env['omniauth.auth']
    session[:spotify_signed_in] = true
    redirect_to root_path
  end

  def destroy
    Rails.cache.clear
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end

  def fetch_twitter_friends
    begin
      client = twitter_client
      verified_friend_names = []
      friends = client.friends({ count: 200, skip_status: true, include_user_entities: false })
      friends.each do |friend|
        if friend.verified?
          verified_friend_names << [friend.name, friend.id]
        end
      end
    rescue Twitter::Error::TooManyRequests => error
      puts "Hit rate limit, will reset in #{error.rate_limit.reset_in}."
      flash[:notice] = "Hit rate limit."
      raise
    end
    Rails.cache.write(session['access_token'], verified_friend_names, expires_in: 1.hour)
  end
end
