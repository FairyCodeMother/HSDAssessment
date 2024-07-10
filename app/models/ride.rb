# app/models/ride.rb

# A Ride consists of a start_address and destination_address. It uses these (via GoogleDirectionsService) to derive the ride_distance (decimal, in miles) and ride_duration (decimal, in hours)
class Ride < ApplicationRecord
  # Validations
  validates :pickup_address, :destination_address, presence: true
  validates :pickup_address, :destination_address, length: { maximum: 255 }
  validates :ride_duration, :ride_distance, presence: true, numericality: { greater_than: 0 }

  attribute :ride_id, :string

  self.primary_key = 'ride_id'
  
  # Callbacks
  before_create :set_ride_id
  
  private
  
  def set_ride_id
    self.ride_id = "r#{SecureRandom.uuid}" if ride_id.blank?
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
