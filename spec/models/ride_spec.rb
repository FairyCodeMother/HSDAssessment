# spec/models/ride_spec.rb
require 'rails_helper'

RSpec.describe Ride, type: :model do
  let(:driver) { Driver.create(driver_id: "D123", home_address: "123 Main St, Anytown, USA") }

  it "is valid with valid attributes" do
    ride = Ride.new(ride_id: "R456", start_address: "456 Elm St, Othertown, USA", destination_address: "789 Oak St, Another Town, USA", driver: driver, ride_distance_miles: 10.5, ride_duration_hours: 0.5)
    expect(ride).to be_valid
  end

  it "is not valid without a ride_id" do
    ride = Ride.new(ride_id: nil, start_address: "456 Elm St, Othertown, USA", destination_address: "789 Oak St, Another Town, USA", driver: driver, ride_distance_miles: 10.5, ride_duration_hours: 0.5)
    expect(ride).to_not be_valid
  end

  it "is not valid without a start_address" do
    ride = Ride.new(ride_id: "R456", start_address: nil, destination_address: "789 Oak St, Another Town, USA", driver: driver, ride_distance_miles: 10.5, ride_duration_hours: 0.5)
    expect(ride).to_not be_valid
  end

  it "is not valid without a destination_address" do
    ride = Ride.new(ride_id: "R456", start_address: "456 Elm St, Othertown, USA", destination_address: nil, driver: driver, ride_distance_miles: 10.5, ride_duration_hours: 0.5)
    expect(ride).to_not be_valid
  end
end
