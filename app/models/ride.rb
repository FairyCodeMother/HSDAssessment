# app/models/ride.rb
# A Ride consists of a start_address and dropoff_address. It uses these (via GoogleDirectionsService) to derive the ride_distance (decimal, in miles) and ride_minutes (decimal, in hours)
class Ride < ApplicationRecord
  has_many :trips

  validates :pickup_address, :dropoff_address, presence: true
  validates :ride_minutes, :ride_miles, :ride_earnings, presence: true, numericality: { greater_than: 0 }

  self.primary_key = 'id'

  # Set Ride ID before creation if blank
  before_create :set_ride_id

  private

  # Custom key starts with "r"
  def set_ride_id
    self.id = "r#{SecureRandom.uuid}" if id.blank?
  end
end
