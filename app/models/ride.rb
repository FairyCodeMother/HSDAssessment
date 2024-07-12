# app/models/ride.rb
# A Ride consists of a start_address and destination_address. It uses these (via GoogleDirectionsService) to derive the ride_distance (decimal, in miles) and ride_minutes (decimal, in hours)
class Ride < ApplicationRecord
  has_many :trips

  validates :pickup_address, :destination_address, presence: true
  validates :ride_minutes, :ride_miles, presence: true, numericality: { greater_than: 0 }

  self.primary_key = 'id'

  # Callbacks
  before_create :set_ride_id

  private

  def set_ride_id
    self.id = "r#{SecureRandom.uuid}" if id.blank?
  end
end
