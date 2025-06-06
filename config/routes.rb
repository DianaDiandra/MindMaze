Rails.application.routes.draw do
  # get "performances/show"
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")

  resources :targets, only: %i[index new create show] do
    # resources :goals, only: %i[new create] ==>seed file
    resources :performances, only: %i[show new create]
    resources :games, only: %i[show index]
  end

  get "my_profile", to: "profiles#my_profile"
  get "/users/search", to: "users#search"
  get "performances/statistics", to: "performances#statistics"
  resources :profiles, only: [:show], param: :username
  resources :performances, only: %i[index]

  # post '/cognifit/token', to: 'cognifit#token'
  # post 'cognifit/get_access_token', to: 'cognifit#get_access_token'
  # post "targets/:target_id/games/:key/play", to: "games#play", as: :play_game
end
