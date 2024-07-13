# app/controllers/trips_controller.rb
class TripsController < ApplicationController
  def index
    calculator = CalculatorService.new

    total_hours = calculator.calculate_trip_minutes(home_address, start_address, destination_address)
    total_miles = calculator.calculate_trip_miles(home_address, start_address, destination_address)

    render json: { times: total_hours, distances: total_miles }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
