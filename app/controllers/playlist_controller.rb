class PlaylistController < ActionController::Base
  def create
    spotify_tracks = []
    friends = JSON.parse(twitter_client.friends.to_json)

    friends.each do |friend|
      if friend["verified"] && friend["name"] != ""
        artists = RSpotify::Artist.search(friend["name"], limit: 5)
        if artists.present? && artists[0].popularity > 20
          top_tracks = artists[0].top_tracks(:US)
          if top_tracks.present?
            spotify_tracks << top_tracks[0]
          end
        end
      end
    end
    spotify_user = RSpotify::User.new(session['spotify_credentials'])
    playlist = spotify_user.create_playlist!('my-first-playlo-playlist')
    playlist.change_details!(public: false)
    playlist.add_tracks!(spotify_tracks)
    session[:playlist_created] = true
    redirect_to root_path
  end

  private

  def twitter_client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.access_token = session['access_token']
      config.access_token_secret = session['access_token_secret']
    end
  end
end
