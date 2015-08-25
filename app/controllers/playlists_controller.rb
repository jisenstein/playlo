class PlaylistsController < ApplicationController
  def create
    friends = Rails.cache.fetch(session['access_token'])
    spotify_credentials = session['spotify_credentials']
    playlist_name = params[:name] || "a playlist"
    type = params[:random] || "top"

    playlist = Playlist.create(total_artists: friends.count, name: playlist_name)

    # Queue job to create playlist
    PlaylistCreator.new.delay.create_playlist(type, playlist_name, friends, spotify_credentials, playlist)
    respond_to do |format|
      format.json {render :json => {status: 200, playlist_id: playlist.id}}
    end
  rescue
    Rails.cache.clear
    reset_session
    flash[:notice] = "Error: had to reset session. Please sign in and try again"
    respond_to do |format|
      format.json {render :json => {status: 400}}
    end
  end

  def update
    p = Playlist.find(params[:id])
    parsed = p.artists_parsed
    total = p.total_artists
    h = {}

    if parsed >= total || parsed < 0
      h[:status] = 200
      h[:alert] = %Q{
        Successfully created your playlist: <strong>#{p.name}</strong>, with #{p.total_artists} tracks. Now go check Spotify!
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
