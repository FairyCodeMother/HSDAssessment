# app/models/trip.rb

# A Trip is made of two parts:
#   - Distance/duration of the Driver's commute (Driver's home_address to Ride's start_address)
#   - Distance/duration for the Ride (Ride's start_address to Ride's destination_address)
class Trip < ApplicationRecord
  # Include any required modules
  require 'google_directions_service'
  require 'trip_calculator'

  # via their primary keys
  has_one :driver
  has_one :ride

  validates :home_address, :start_address, :destination_address, presence: true
  validates :home_address, :start_address, :destination_address, length: { maximum: 255 }
  validates :ride_earnings, numericality: { greater_than_or_equal_to: 0 }

  # Define attributes
  attribute :home_address, :string
  attribute :start_address, :string
  attribute :destination_address, :string
  attribute :ride_earnings, :decimal, default: 0
  attribute :commute_distance, :decimal, default: 0
  attribute :commute_duration, :decimal, default: 0
  attribute :ride_distance, :decimal, default: 0
  attribute :ride_duration, :decimal, default: 0
  attribute :total_distance, :decimal, default: 0
  attribute :total_duration, :decimal, default: 0

  attr_accessor :commute_distance, :commute_duration, :total_distance, :total_duration


  def calculate_commute_duration
    TripCalculator.new.calculate_duration([home_address], [start_address])
  end

  def calculate_commute_distance
    TripCalculator.new.calculate_distance([home_address], [start_address])
  end

  def calculate_total_duration
    total_trip = TripCalculator.new.calculate_trip_duration(home_address, start_address, destination_address)
    total_trip.total_duration
    # calculate_commute_duration + Ride.find(ride_id).ride_duration
  end

  def calculate_total_distance
    total_trip = TripCalculator.new.calculate_trip_distance(home_address, start_address, destination_address)
    total_trip.total_distance
    # calculate_commute_distance + Ride.find(ride_id).ride_distance
  end


  before_save :set_distances_and_durations


  private

  def set_distances_and_durations
    self.commute_duration = calculate_commute_duration
    self.commute_distance = calculate_commute_distance
    self.total_duration = calculate_total_duration
    self.total_distance = calculate_total_distance
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
