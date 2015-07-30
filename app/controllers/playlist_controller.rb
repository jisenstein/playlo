class PlaylistController < ApplicationController
  def create
    spotify_tracks = []
    puts "ready to create a playlist"
    type = params[:random] || "top"
    playlist_name = params[:name] || "a playlist"

    friends = Rails.cache.fetch(session['access_token'])
    begin
      if !friends.blank?
        friends.each do |friend|
          puts "fetching artist for #{friend}"
          artists = RSpotify::Artist.search(friend, limit: 1)
          if (a = artists[0]) && a.popularity > 20
            puts "got artist match #{a.name}"
            spotify_tracks << case type
            when "top"
              a.top_tracks(:US).first
            when "random"
              a.top_tracks(:US).sample
            when "super_random"
              a.albums(limit: 7, country: 'US').sample.tracks.sample
            end
          end
        end
      end
    rescue RestClient::TooManyRequests => error
      puts "GOT A SPOTIFY RATE LIMIT"
      puts error
      flash[:notice] = "Hit spotify rate limit."
      if spotify_tracks.count > 0
        return
      else
        redirect_to root_path
      end
    end

    puts "finished searching for tracks"
    puts "about to log into spotify"

    if !spotify_tracks.blank?
      spotify_user = RSpotify::User.new(session['spotify_credentials'])

      puts "logged into spotify"

      playlist = spotify_user.create_playlist!(playlist_name)
      playlist.change_details!(public: false)
      playlist.add_tracks!(spotify_tracks)
      puts "successfully created playlist"
      flash[:notice] = "Just made #{playlist_name}!"
    else
      flash[:notice] = "found 0 tracks, did not create playlist"
    end

    redirect_to root_path
  end
end
