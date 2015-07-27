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
      slug = client.user.screen_name
      session[:slug] = slug
      if (user = User.find_by_slug(slug))
        @friends = user.twitter_friends
      else
        user = User.create_new(slug, @client)
        @friends = user.twitter_friends
      end
    else
      redirect_to failure_path
    end
  end

  def test
    debugger
    render text: 'josh test'
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
