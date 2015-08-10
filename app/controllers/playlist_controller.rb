class PlaylistController < ApplicationController
  def create
    friends = Rails.cache.fetch(session['access_token'])
    spotify_credentials = session['spotify_credentials']

    # Queue job to create playlist
    PlaylistCreator.new.delay.create_playlist(params[:random], params[:name], friends, spotify_credentials)
    flash[:notice] = "Creating playlist: '#{params[:name]}'."
    redirect_to root_path
  end
end
