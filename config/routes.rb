# config/routes.rb
Rails.application.routes.draw do
  
  resources :rides, only: [:index, :show, :create, :update, :destroy] do
    post 'calculate_score_and_render', on: :collection
  end
  
  resources :trips

  # GET Trips by driver_id (/drivers/:id/trips)
  resources :drivers do
    get 'trips', to: 'drivers#get_trips_by_driver_id', on: :member
  end
  
  # Health check route: returns 200 if app boots with no exceptions (otherwise 500)
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "posts#index"
end
