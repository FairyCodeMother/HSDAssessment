# app/controllers/trips_controller.rb
class TripsController < ApplicationController
  def index
    calculator = TripCalculator.new
    
    total_hours = calculator.calculate_trip_duration(home_address, start_address, destination_address)
    total_miles = calculator.calculate_trip_distance(home_address, start_address, destination_address)
    
    render json: { times: total_hours, distances: total_miles }
  end
end