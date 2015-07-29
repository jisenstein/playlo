class PlaylistController < ApplicationController
  def create
    spotify_tracks = []
    puts "ready to create a playlist"

    friends = Rails.cache.fetch(session['access_token'])
    if !friends.blank?
      friends.each do |friend|
        artists = RSpotify::Artist.search(friend, limit: 1)
        if (a = artists[0]) && a.popularity > 20
          top_tracks = a.top_tracks(:US)
          if (t = top_tracks[0]) && t.popularity > 20
            puts "Twitter name: #{friend} --- Artist name: #{a.name}"
            puts "Artist popularity: #{a.popularity} --- Track popularity: #{t.popularity}"
            spotify_tracks << t
          end
        end
      end
    end

    puts "finished searching for tracks"
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
