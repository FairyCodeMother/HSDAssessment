# app/models/driver.rb

# A Driver consists of a name and home_address
class Driver < ApplicationRecord
  has_many :rides
  has_many :trips

  validates :name, :home_address, presence: true
  validates :home_address, length: { maximum: 255 }

  self.primary_key = 'driver_id'
  
  # Callbacks
  before_create :set_driver_id
  
  private

  def set_driver_id
    self.driver_id = "d#{SecureRandom.uuid}" if driver_id.blank?
  end
end
