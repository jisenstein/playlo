class SpotifyController < ActionController::Base
  def index
    debugger
    session['spotify_credentials'] = request.env['omniauth.auth']

    # spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    render text: 'spotify success!'
  end

  def create_playlist
    user = User.find_by_slug(session[:slug])
    track_ids = []
    user.twitter_friends.each do |f|
      if (sa = f.spotify_artist)
        track_ids << sa.tracks[0].spotify_track_id
      end
    end
    spotify_user = RSpotify::User.new(session['spotify_credentials'])
    playlist = spotify_user.create_playlist!('my-first-playlo-playlist') 
    playlist.add_tracks!(RSpotify::Track.find(track_ids))
    playlist.change_details!(public: false)
    render text: 'playlist created!'
  end
end
