# app/models/trip.rb

# A Trip is made of two parts:
#   - Distance/duration of the Driver's commute (Driver's home_address to Ride's start_address)
#   - Distance/duration for the Ride (Ride's start_address to Ride's destination_address)
class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :ride

  validates :driver_id, :ride_id, presence: true
  validates :commute_minutes, :commute_miles, :total_hours, :total_minutes, :total_miles, :earnings, numericality: { greater_than: 0 }

  self.primary_key = 'id'

  # Callbacks
  before_create :set_trip_id

  private

  def set_trip_id
    self.id = "t#{SecureRandom.uuid}" if id.blank?
  end
end
