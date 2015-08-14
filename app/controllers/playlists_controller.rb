class PlaylistsController < ApplicationController
  def create
    friends = Rails.cache.fetch(session['access_token'])
    spotify_credentials = session['spotify_credentials']
    playlist_name = params[:name] || "a playlist"
    type = params[:random] || "top"

    playlist = Playlist.create(total_artists: friends.count, name: playlist_name)

    # Queue job to create playlist
    PlaylistCreator.new.delay.create_playlist(type, playlist_name, friends, spotify_credentials, playlist)
    # flash[:notice] = "Creating playlist: '#{params[:name]}'."
    respond_to do |format|
      format.json {render :json => {status: 200, playlist_id: playlist.id}}
    end
    # redirect_to root_path
  end

  def update
    # debugger
    p = Playlist.find(params[:id])
    parsed = p.artists_parsed
    total = p.total_artists
    h = {}

    if parsed >= total || parsed < 0
      h[:status] = 200
      h[:alert] = %Q{
        <h3 class='alert alert-info' role='alert'>
          Successfully created your playlist: \"#{p.name}\", with #{p.total_artists} tracks. Now go check Spotify!
        </h3>
      }
      p.destroy
    else
      percent = [((parsed.to_f/total.to_f) * 100), 2].max.floor.to_s + "%"
      h[:percent] = percent
      h[:status] = 400
    end

    respond_to do |format|
      format.json {render :json => h}
    end
  end
end
