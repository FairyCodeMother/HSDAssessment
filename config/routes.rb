# config/routes.rb
Rails.application.routes.draw do
  resources :trips
  resources :drivers
  resources :rides

  # Health check route: returns 200 if app boots with no exceptions (otherwise 500)
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # GET Trips by driver_id (/drivers/:id/trips)
  resources :drivers, only: [] do
    get 'trips', to: 'rides#get_trips_by_driver', on: :member
  end

end
