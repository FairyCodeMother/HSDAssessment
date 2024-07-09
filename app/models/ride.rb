# app/models/ride.rb

# A Ride consists of a start_address and destination_address. It uses these (via GoogleDirectionsService) to derive the ride_distance (decimal, in miles) and ride_duration (decimal, in hours)
class Ride < ApplicationRecord
  # Include any required modules
  require 'google_directions_service'
  require 'trip_calculator'

    # Define validations
  validates :start_address, :destination_address, presence: true
  validates :start_address, :destination_address, length: { maximum: 255 }

  # Define attributes
  attribute :start_address, :string
  attribute :destination_address, :string
  attribute :ride_distance, :decimal, default: 0
  attribute :ride_duration, :decimal, default: 0

  attr_accessor :start_address, :destination_address, :ride_distance, :ride_duration
  
  def calculate_ride_duration
    GoogleDirectionsService.new.get_duration_hours([start_address], [destination_address])
  end

  def calculate_ride_distance
    GoogleDirectionsService.new.get_distance_miles([start_address], [destination_address])
  end


  # Callback to calculate distances and durations before saving
  before_save :set_distances_and_durations

  private

  def set_distances_and_durations
    self.ride_duration = calculate_ride_duration
    self.ride_distance = calculate_ride_distance
  end
end


# # Create a new Ride instance
# ride = Ride.new(start_address: "123 Main St", destination_address: "456 Elm St")

# # Access the attributes
# puts ride.start_address       # => "123 Main St"
# puts ride.destination_address # => "456 Elm St"

# # Update the attributes
# ride.start_address = "789 Oak St"
# ride.destination_address = "101 Pine St"

# # Save the ride to trigger the before_save callback
# ride.save

# # Check the updated attributes
# puts ride.start_address       # => "789 Oak St"
# puts ride.destination_address # => "101 Pine St"
# puts ride.ride_distance       # => (calculated distance in miles)
# puts ride.ride_duration       # => (calculated duration in hours)
