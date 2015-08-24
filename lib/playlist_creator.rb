class PlaylistCreator
  UNIT = 5
  def create_playlist(type, playlist_name, friends, spotify_credentials, playlist_record)
    puts "Ready to create a playlist: #{playlist_name}."
    @p = playlist_record
    @track_count = 0

    # Create user and blank playlist.
    spotify_user = RSpotify::User.new(spotify_credentials)
    playlist = spotify_user.create_playlist!(playlist_name)
    playlist.change_details!(public: false)
    count = 1

    begin
      if !friends.blank?
        friends.shuffle.each do |friend, twitter_id|
          if count % UNIT == 0
            @p.save
          end
          if (match = TwitterSpotifyMapping.find_by_twitter_id(twitter_id))
            puts "Fetched match from database."
            if match.spotify_artist_id.present?
              a = RSpotify::Artist.find(match.spotify_artist_id)
              playlist.add_tracks!([send(type, a)])
              @track_count += 1
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
                @track_count += 1
              end
            end
            new_match.save
          end
          @p.artists_parsed += 1
          count += 1
        end
      else
        puts "No Twitter friends, created empty playlist."
      end
    rescue RestClient::TooManyRequests => error
      puts "Error: spotify rate limit -- #{error}"
    end
  end

  def after()
    @p.artists_parsed = -1
    @p.total_artists = @track_count
    @p.save
  end

  # def error()
  # end

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
