# app/models/driver.rb

# A Driver consists of a name and home_address
class Driver < ApplicationRecord
  has_many :trips

  validates :home_address, presence: true

  self.primary_key = 'id'

  # Get all Rides for this Driver
  def get_all_driver_rides
    # Ride.where(FULFILLS SOME RULESET- within range of driver, etc)
    Ride.all
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Rides not found' }, status: :not_found
  end

  # Callbacks
  before_create :set_driver_id

  private

  def set_driver_id
    self.id = "d#{SecureRandom.uuid}" if id.blank?
  end
end
