class PlaylistCreator
  def create_playlist(param_type, param_name, friends, spotify_credentials)
    puts "ready to create a playlist"
    type = param_type || "top"

    playlist_name = param_name || "a playlist"

    spotify_user = RSpotify::User.new(spotify_credentials)
    playlist = spotify_user.create_playlist!(playlist_name)
    playlist.change_details!(public: false)

    begin
      if !friends.blank?
        friends.shuffle.each do |friend|
          puts "fetching artist for #{friend}"
          artists = RSpotify::Artist.search(friend, limit: 1)
          if (a = artists[0]) && a.popularity > 20
            puts "got artist match #{a.name}"
            track = send(type, a)
            if track.class == RSpotify::Track
              playlist.add_tracks!([send(type, a)])
            end
          end
        end
      else
        puts "friends is blank"
      end
    rescue RestClient::TooManyRequests => error
      puts "spotify rate limit"
      puts "error"
      puts error
    end
  end

  def top(a)
    a.top_tracks(:US).first
  end

  def random(a)
    a.top_tracks(:US).sample
  end

  def super_random(a)
    a.albums(limit: 7, country: 'US').sample.tracks.sample
  end
end
