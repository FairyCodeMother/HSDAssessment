# spec/models/ride_spec.rb
require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'Ride factories create rides from the array' do
    it 'creates four test rides' do
      FactoryBot.create_list(:ride, 4)

      expect(Ride.count).to eq(4)

      # Retrieve all rides
      rides = Ride.all
      rides.each_with_index do |ride, index|
        puts "Ride #{index + 1}:"
        puts "Pickup Address: #{ride.pickup_address}"
        # puts "Dropoff Address: #{ride.dropoff_address}"
        # puts "Ride Minutes: #{ride.ride_minutes}"
        # puts "Ride Miles: #{ride.ride_miles}"
        # puts "Ride Earnings: #{ride.ride_earnings}"
        puts "------------------"
      end

      expect(rides.first.pickup_address).to eq('2401 E 6th St, Austin, TX')
      expect(rides.last.dropoff_address).to eq('4000 S IH 35 Frontage Rd, Austin, TX')
    end

    # Test for the presence validations
    # context 'validations' do
    #   it 'is valid with valid attributes' do
    #     ride = build(:ride)
    #     expect(ride).to be_valid
    #   end
    # end

end



# # Example of further assertions based on your application logic
# # You can assert specific attributes or behaviors here
# expect(rides.first.pickup_address).to eq('2401 E 6th St, Austin, TX')
# expect(rides.last.dropoff_address).to eq('4000 S IH 35 Frontage Rd, Austin, TX')



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
