Rails.application.routes.draw do
  get "performances/show"
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

  resources :games, only: %i[index show] do
    resources :performances, only: %i[index new create show]
  end
  resources :targets, only: %i[index new create show]
  get "my_profile", to: "profiles#my_profile"
  resources :performances, only: [:index]
end
