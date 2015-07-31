class PlaylistCreator
  Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'dj.log'))
  def create_playlist(param_type, param_name, friends, spotify_credentials)
    spotify_tracks = []
    Delayed::Worker.logger.debug("ready to create a playlist")
    puts "ready to create a playlist"
    type = param_type || "top"

    playlist_name = param_name || "a playlist"

    # friends = Rails.cache.fetch(cache_key)
    begin
      if !friends.blank?
        friends.each do |friend|
          Delayed::Worker.logger.debug("fetching artist for #{friend}")
          puts "fetching artist for #{friend}"
          artists = RSpotify::Artist.search(friend, limit: 1)
          if (a = artists[0]) && a.popularity > 20
            Delayed::Worker.logger.debug("got artist match #{a.name}")
            puts "got artist match #{a.name}"
            track = send(type, a)
            if track.class == RSpotify::Track
              spotify_tracks << send(type, a)
            end
          end
        end
      else
        puts "friends is blank"
      end
    rescue RestClient::TooManyRequests => error
      puts "spotify rate limit"
      puts "error"
      Delayed::Worker.logger.debug(error)
    end

    Delayed::Worker.logger.debug("about to log into spotify")
    puts "logging into spotify"

    if !spotify_tracks.blank?
      spotify_user = RSpotify::User.new(spotify_credentials)

      Delayed::Worker.logger.debug("logged into spotify")
      puts "logged in"

      playlist = spotify_user.create_playlist!(playlist_name)
      playlist.change_details!(public: false)
      playlist.add_tracks!(spotify_tracks.shuffle)
      Delayed::Worker.logger.debug("successfully created playlist")
    else
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
