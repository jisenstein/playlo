class SessionsController < ActionController::Base
  def twitter
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    session[:twitter_signed_in] = true
    redirect_to root_path
  end

  def spotify
    session[:spotify_credentials] = request.env['omniauth.auth']
    session[:spotify_signed_in] = true
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end
end
