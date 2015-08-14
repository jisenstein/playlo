Rails.application.routes.draw do
  root 'application#index', as: 'root'

  get '/auth/twitter/callback', to: 'sessions#twitter'
  get '/auth/spotify/callback', to: 'sessions#spotify'
  get '/signout', to: 'sessions#destroy'

  resources :playlists
  # get '/create_playlist', to: 'playlist#create'

  # get '/'
end
