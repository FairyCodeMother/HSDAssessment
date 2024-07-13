# config/routes.rb
Rails.application.routes.draw do

  # Rides endpoints
  resources :rides, only: [:index, :show, :create, :update, :destroy]

  # Trips endpoints
  resources :trips

  # GET Trips by user_driver_id (/user_drivers/:id/trips)
  resources :user_drivers, only: [] do
    get 'trips', to: 'user_drivers#get_trips_by_user_driver_id', on: :member
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path route
  root "posts#index"
end
