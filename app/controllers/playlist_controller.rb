class PlaylistController < ActionController::Base
  def create
    spotify_tracks = []
    puts "ready to create a playlist"

    # friends = JSON.parse(twitter_client.friends.to_json)

    friends = Rails.cache.fetch(session['access_token'])
    friends.each do |friend|
      artists = RSpotify::Artist.search(friend, limit: 5)
      if artists.present? && artists[0].popularity > 20
        top_tracks = artists[0].top_tracks(:US)
        if top_tracks.present?
          spotify_tracks << top_tracks[0]
        end
      end
    end

    # friends.each do |friend|
    #   if friend["verified"] && friend["name"] != ""
    #     artists = RSpotify::Artist.search(friend["name"], limit: 5)
    #     if artists.present? && artists[0].popularity > 20
    #       top_tracks = artists[0].top_tracks(:US)
    #       if top_tracks.present?
    #         spotify_tracks << top_tracks[0]
    #       end
    #     end
    #   end
    # end

    puts "finished searching for tracks"

    if spotify_tracks.blank?
      session[:no_tracks] = true
      redirect_to root_path
    else
      puts "about to log into spotify"
      spotify_user = RSpotify::User.new(session['spotify_credentials'])
      puts "logged into spotify"
      playlist = spotify_user.create_playlist!('my-first-playlo-playlist')
      playlist.change_details!(public: false)
      playlist.add_tracks!(spotify_tracks)
      puts "successfully created playlist"
      session[:playlist_created] = true
      redirect_to root_path
    end
  end
end
