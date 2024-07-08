# app/models/driver.rb
class Driver < ApplicationRecord
  has_many :rides

  def calculate_commute(ride)
    service = GoogleDirectionsService.new(ENV['GOOGLE_MAPS_API_KEY'])
    commute_distance_miles = service.driving_distance(home_address, ride.start_address)
    commute_duration_hours = service.driving_duration(home_address, ride.start_address)
    [commute_distance_miles, commute_duration_hours]
  end
end