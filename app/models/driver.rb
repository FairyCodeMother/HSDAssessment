# app/models/driver.rb
class Driver < ApplicationRecord
    has_many :rides
    validates :driver_id, presence: true, uniqueness: true
    validates :home_address, presence: true
  
    before_validation :generate_driver_id, on: :create
  
    private
  
    def generate_driver_id
      self.driver_id = "D#{SecureRandom.hex(4)}" if driver_id.blank?
    end
  end
  