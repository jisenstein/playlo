class PlaylistController < ApplicationController
  def create
    friends = Rails.cache.fetch(session['access_token'])
    spotify_credentials = session['spotify_credentials']
    PlaylistCreator.new.delay.create_playlist(params[:random], params[:name], friends, spotify_credentials)
    flash[:notice] = "Queued up a job to make #{params[:name]}"
    redirect_to root_path
  end
end
