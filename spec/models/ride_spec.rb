# spec/models/ride_spec.rb
require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'factories' do

    it 'creates rides from the array with calculated ride minutes and miles' do
      # Create a ride using the factory with the :from_array trait
      create(:ride, :from_array)

      # Expectation: Check if the ride was created
      expect(Ride.count).to eq(3) # Check if 3 rides were created from the array

      # Optional: Output the created rides for inspection
      # Ride.all.each do |ride|
      #   puts "Ride ID: #{ride.id}, Pickup Address: #{ride.pickup_address}, Dropoff Address: #{ride.dropoff_address}, Ride Minutes: #{ride.ride_minutes}, Ride Miles: #{ride.ride_miles}"
      # end

      # Additional expectations based on your requirements:
      # - Check if ride_minutes and ride_miles are calculated correctly
      # - Check other attributes as needed
      # expect(Ride.first.ride_minutes).to be_present
      # expect(Ride.first.ride_miles).to be_present
    end
  end



  # # Test for the presence validations
  # context 'validations' do
  #   it 'is valid with valid attributes' do
  #     ride = build(:ride)
  #     expect(ride).to be_valid
  #   end

  #   it 'is not valid without a pickup_address' do
  #     ride = build(:ride, pickup_address: nil)
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:pickup_address]).to include("can't be blank")
  #   end

  #   it 'is not valid without a dropoff_address' do
  #     ride = build(:ride, dropoff_address: nil)
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:dropoff_address]).to include("can't be blank")
  #   end

  #   it 'is not valid without ride_minutes' do
  #     ride = build(:ride, ride_minutes: nil)
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_minutes]).to include("can't be blank")
  #   end

  #   it 'is not valid without ride_miles' do
  #     ride = build(:ride, ride_miles: nil)
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_miles]).to include("can't be blank")
  #   end

  #   it 'is not valid with non-numeric ride_minutes' do
  #     ride = build(:ride, ride_minutes: 'abc')
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_minutes]).to include('is not a number')
  #   end

  #   it 'is not valid with non-numeric ride_miles' do
  #     ride = build(:ride, ride_miles: 'abc')
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_miles]).to include('is not a number')
  #   end

  #   it 'is not valid with non-numeric ride_earnings' do
  #     ride = build(:ride, ride_earnings: 'abc')
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_earnings]).to include('is not a number')
  #   end

  #   it 'is not valid with ride_minutes less than or equal to 0' do
  #     ride = build(:ride, ride_minutes: 0)
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_minutes]).to include('must be greater than 0')
  #   end

  #   it 'is not valid with ride_miles less than or equal to 0' do
  #     ride = build(:ride, ride_miles: 0)
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_miles]).to include('must be greater than 0')
  #   end

  #   it 'is not valid with ride_earnings less than or equal to 0' do
  #     ride = build(:ride, ride_earnings: 0)
  #     expect(ride).not_to be_valid
  #     expect(ride.errors[:ride_earnings]).to include('must be greater than 0')
  #   end
  # end

  # # Test for setting the custom primary key
  # context 'before_create callback' do
  #   it 'sets the ride ID if blank' do
  #     ride = build(:ride, id: nil)
  #     ride.save
  #     expect(ride.id).to match(/^r[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
  #   end

  #   it 'does not change the ride ID if it is already set' do
  #     id = "r#{SecureRandom.uuid}"
  #     ride = build(:ride, id: id)
  #     ride.save
  #     expect(ride.id).to eq(id)
  #   end
  # end





end
