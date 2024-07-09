# app/controllers/trips_controller.rb
class TripsController < ApplicationController
  def index
    calculator = TripCalculator.new
    
    hours = calculator.calculate_trip_duration(home_address, start_address, destination_address)
    miles = calculator.calculate_trip_distance(home_address, start_address, destination_address)
    
    render json: { times: hours, distances: miles }
  end
end