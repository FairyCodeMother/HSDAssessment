# app/controllers/rides_controller.rb
class RidesController < ApplicationController
    def index
        service = GoogleDirectionsService.new
      
        hours = service.get_duration_hours(start_address, destination_address)
        miles = service.get_distance_miles(home_address, start_address, destination_address)
      
        render json: { times: hours, distances: miles }
    end
end
  