# spec/models/ride_spec.rb
require 'rails_helper'

RSpec.describe Ride, type: :model do
  # describe 'Ride factories create rides from array with Calculations' do
  #   it 'creates four test rides' do
  #     FactoryBot.create_list(:ride, 4)

  #     expect(Ride.count).to eq(4)

  #     # Retrieve all rides
  #     rides = Ride.all
  #     rides.each_with_index do |ride, index|
  #       puts "RIDE Ride #{index + 1}:"
  #       puts "Pickup Address: #{ride.pickup_address}"
  #       puts "======================\n"
  #     end

  #     expect(rides.first.pickup_address).to eq('4700 West Guadalupe, Austin, TX')
  #     expect(rides.last.dropoff_address).to eq('11706 Argonne Forest Trail, Austin, TX')
  #   end
  # end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      ride = FactoryBot.build(:ride)
      expect(ride).to be_valid
    end

    it 'is invalid without a pickup_address' do
      ride = FactoryBot.build(:ride, pickup_address: nil)
      expect(ride).not_to be_valid
      expect(ride.errors[:pickup_address]).to include("can't be blank")
    end

    it 'is invalid without a dropoff_address' do
      ride = FactoryBot.build(:ride, dropoff_address: nil)
      expect(ride).not_to be_valid
      expect(ride.errors[:dropoff_address]).to include("can't be blank")
    end

    it 'is invalid without ride_minutes' do
      ride = FactoryBot.build(:ride, ride_minutes: nil)
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_minutes]).to include("can't be blank")
    end

    it 'is invalid without ride_miles' do
      ride = FactoryBot.build(:ride, ride_miles: nil)
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_miles]).to include("can't be blank")
    end

    it 'is invalid with non-numeric ride_minutes' do
      ride = FactoryBot.build(:ride, ride_minutes: 'abc')
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_minutes]).to include("is not a number")
    end

    it 'is invalid with non-numeric ride_miles' do
      ride = FactoryBot.build(:ride, ride_miles: 'abc')
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_miles]).to include("is not a number")
    end

    it 'is invalid with non-numeric ride_earnings' do
      ride = FactoryBot.build(:ride, ride_earnings: 'abc')
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_earnings]).to include("is not a number")
    end

    it 'is invalid with negative ride_minutes' do
      ride = FactoryBot.build(:ride, ride_minutes: -1)
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_minutes]).to include("must be greater than 0")
    end

    it 'is invalid with negative ride_miles' do
      ride = FactoryBot.build(:ride, ride_miles: -1)
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_miles]).to include("must be greater than 0")
    end

    it 'is invalid with negative ride_earnings' do
      ride = FactoryBot.build(:ride, ride_earnings: -1)
      expect(ride).not_to be_valid
      expect(ride.errors[:ride_earnings]).to include("must be greater than 0")
    end
  end


  describe 'Custom methods' do
    it 'sets a custom ride ID before creation' do
      ride = FactoryBot.create(:ride)
      expect(ride.id).to start_with('r')
    end
  end

end
