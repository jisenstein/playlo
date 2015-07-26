class SessionsController < ApplicationController
  def create
    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    redirect_to show_path, notice: 'Signed in'
  end

  def show
    if session['access_token'] && session['access_token_secret']
      debugger
      #debugger
      # @user = client.user(include_entities: true)
      if !@friends
        friends = JSON.parse(client.friends.to_json)
        @friends = []
        friends.each do |friend|
          @friends << [friend["name"], friend["screen_name"]]
        end
      end
    else
      redirect_to failure_path
    end
  end

  def error
    flash[:error] = 'Sign in with Twitter failed'
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Signed out'
  end
end
