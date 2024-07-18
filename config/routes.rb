# config/routes.rb
Rails.application.routes.draw do

  # Rides endpoints
  resources :rides, only: [:index, :show, :create, :update, :destroy]

  # Trips endpoints
  resources :trips, only: [:index, :show, :create, :update, :destroy]

  # Chauffeurs endpoints
  resources :chauffeurs, only: [:index, :show, :create, :update, :destroy] do
    # GET Trips by chauffeur_id (/chauffeurs/:id/trips)
    get 'trips', to: 'chauffeurs#create_trips_by_chauffeur_id', on: :member
    post 'trips', to: 'trips#create', on: :member
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path route
  root "posts#index"
end
