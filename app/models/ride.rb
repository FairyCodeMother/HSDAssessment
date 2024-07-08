# app/models/ride.rb
class Ride < ApplicationRecord
  before_save :calculate_distances_and_durations

  private

  def calculate_distances_and_durations
    service = GoogleDirectionsService.new(ENV['GOOGLE_MAPS_API_KEY'])
    self.ride_distance_miles = service.driving_distance(start_address, destination_address)
    self.ride_duration_hours = service.driving_duration(start_address, destination_address)
  end
end