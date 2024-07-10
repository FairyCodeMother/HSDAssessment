# app/models/trip.rb

# A Trip is made of two parts:
#   - Distance/duration of the Driver's commute (Driver's home_address to Ride's start_address)
#   - Distance/duration for the Ride (Ride's start_address to Ride's destination_address)
class Trip < ApplicationRecord

  self.primary_key = 'trip_id'
  belongs_to :driver, primary_key: 'driver_id', foreign_key: 'driver_id'
  belongs_to :ride, primary_key: 'ride_id', foreign_key: 'ride_id'

  validates :driver_id, :ride_id, presence: true
  validates :commute_duration, :commute_distance, :total_duration, :total_distance, numericality: { greater_than: 0 }, allow_nil: true

  # Callbacks
  before_create :set_trip_id

  private

  def set_trip_id
    self.trip_id = "t#{SecureRandom.uuid}" if trip_id.blank?
  end
end


# # Create a new Trip instance
# trip = Trip.new(
#   home_address: "123 Main St",
#   start_address: "456 Elm St",
#   destination_address: "789 Oak St",
#   driver_id: 1,
#   ride_id: 1
# )

# # Access and update the attributes
# trip.commute_distance = trip.calculate_commute_distance
# trip.commute_duration = trip.calculate_commute_duration
# trip.total_distance = trip.calculate_total_distance
# trip.total_duration = trip.calculate_total_duration

# # Save the trip to trigger the before_save callback
# trip.save

# # Check the updated attributes
# puts trip.commute_distance  # => (calculated distance in miles)
# puts trip.commute_duration  # => (calculated duration in hours)
# puts trip.total_distance    # => (calculated total distance in miles)
# puts trip.total_duration    # => (calculated total duration in hours)
