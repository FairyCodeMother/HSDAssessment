# config/routes.rb
Rails.application.routes.draw do

  # Health check route: returns 200 if app boots with no exceptions (otherwise 500)
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # REST: /drivers/:id/trips
  # Get Trips by driver_id
  resources :drivers, only: [] do
    get 'trips', to: 'rides#get_trips_by_driver', on: :member
  end

end
