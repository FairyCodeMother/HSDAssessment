# spec/models/driver_spec.rb
require 'rails_helper'

RSpec.describe Driver, type: :model do
  it "is valid with valid attributes" do
    driver = Driver.new(driver_id: "D123", home_address: "123 Main St, Anytown, USA")
    expect(driver).to be_valid
  end

  it "is not valid without a driver_id" do
    driver = Driver.new(driver_id: nil, home_address: "123 Main St, Anytown, USA")
    expect(driver).to_not be_valid
  end

  it "is not valid without a home_address" do
    driver = Driver.new(driver_id: "D123", home_address: nil)
    expect(driver).to_not be_valid
  end
end
