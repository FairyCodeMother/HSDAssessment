# app/models/user_driver.rb

# A UserDriver consists of a name and home_address
class UserDriver < ApplicationRecord
  has_many :trips

  validates :home_address, presence: true

  self.primary_key = 'id'

  # Get all Rides for this UserDriver
  def get_all_user_driver_rides
    # Example filtering logic (adjust as per your actual business rules)
    # Fetching all Rides (from seeds) for now
    Ride.all
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Rides not found' }, status: :not_found
  end

  # Set UserDriver ID before creation if blank
  before_create :set_user_driver_id

  private

  # Custom key starts with "u"
  def set_user_driver_id
    self.id = "u#{SecureRandom.uuid}" if id.blank?
  end
end
