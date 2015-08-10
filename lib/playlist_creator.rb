class PlaylistCreator
  def create_playlist(param_type, param_name, friends, spotify_credentials)
    playlist_name = param_name || "a playlist"
    type = param_type || "top"

    puts "Ready to create a playlist: #{playlist_name}."

    # Create user and empty playlist.
    spotify_user = RSpotify::User.new(spotify_credentials)
    playlist = spotify_user.create_playlist!(playlist_name)
    playlist.change_details!(public: false)

    begin
      if !friends.blank?
        friends.shuffle.each do |friend, twitter_id|
          if (match = TwitterSpotifyMapping.find_by_twitter_id(twitter_id))
            puts "Fetched match from database."
            if match.spotify_artist_id.present?
              a = RSpotify::Artist.find(match.spotify_artist_id)
              playlist.add_tracks!([send(type, a)])
            end
          else
            puts "New twitter account."
            new_match = TwitterSpotifyMapping.new(twitter_id: twitter_id, twitter_name: friend)
            artists = RSpotify::Artist.search(friend, limit: 1)
            if (a = artists[0]) && a.popularity > 20
              puts "Got artist match: #{a.name}."
              new_match.spotify_artist_id = a.id
              new_match.spotify_name = a.name
              track = send(type, a)
              if track.class == RSpotify::Track
                playlist.add_tracks!([track])
              end
            end
            new_match.save
          end
        end
      else
        puts "No Twitter friends, created empty playlist."
      end
    rescue RestClient::TooManyRequests => error
      puts "Error: spotify rate limit -- #{error}"
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
