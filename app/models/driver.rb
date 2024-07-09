# app/models/driver.rb

# A Driver is an entity with a home_address
class Driver < ApplicationRecord
  require 'google_directions_service'
  require 'trip_calculator'

  has_many :rides
  has_many :trips

  validates :name, :home_address, presence: true
  validates :home_address, length: { maximum: 255 }

  attribute :name, :string
  attribute :home_address, :string
  
  attr_accessor :home_address

  def update_home_address(new_home_address)
    self.home_address = new_home_address
    if valid?
      save
      true
    else
      false
    end
  end

end
