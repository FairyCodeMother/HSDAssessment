# app/models/driver.rb

# A Driver is an entity with a home_address
class Driver < ApplicationRecord
  # Include any required modules
  require 'google_directions_service'
  require 'trip_calculator'

  # Define associations
  has_many :trips

  # Define validations
  validates :name, :home_address, presence: true
  validates :home_address, length: { maximum: 255 }

  # Define attributes
  attribute :name, :string
  attribute :home_address, :string
  
  # Define accessors/mutators
  attr_accessor :home_address

  # Instance methods
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
