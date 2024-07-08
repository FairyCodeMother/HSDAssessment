# app/models/ride.rb
class Ride < ApplicationRecord
    belongs_to :driver, optional: true
    validates :ride_id, presence: true, uniqueness: true
    validates :start_address, :destination_address, presence: true
  
    before_validation :generate_ride_id, on: :create
  
    private
  
    def generate_ride_id
      self.ride_id = "R#{SecureRandom.hex(4)}" if ride_id.blank?
    end
  end
  