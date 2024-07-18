# spec/models/trip_spec.rb

require 'rails_helper'

RSpec.describe Trip, type: :model do
  # Ensure all rides are created before running tests
  before(:all) do
    FactoryBot.create_list(:ride, 4)
  end

  describe 'associations' do
    it { should belong_to(:chauffeur) }
    it { should belong_to(:ride) }
  end

  describe 'validations' do
    it { should validate_presence_of(:chauffeur_id) }
    it { should validate_presence_of(:ride_id) }
    it { should validate_presence_of(:commute_minutes) }
    it { should validate_presence_of(:commute_miles) }
    it { should validate_presence_of(:total_hours) }
    it { should validate_presence_of(:total_minutes) }
    it { should validate_presence_of(:total_miles) }
    it { should validate_presence_of(:score) }
    it { should validate_numericality_of(:commute_minutes).is_greater_than(0) }
    it { should validate_numericality_of(:commute_miles).is_greater_than(0) }
    it { should validate_numericality_of(:total_hours).is_greater_than(0) }
    it { should validate_numericality_of(:total_minutes).is_greater_than(0) }
    it { should validate_numericality_of(:total_miles).is_greater_than(0) }
    it { should validate_numericality_of(:score).is_greater_than(0) }
  end

  describe '.create_trip_by_ids' do
    it 'creates a trip with correct attributes using real CalculatorService results' do
      # Create specific test chauffeur
      chauffeur = create(:chauffeur, home_address: '1201 S Lamar Blvd, Austin, TX')

      # Create specific test ride
      ride = create(:ride, pickup_address: '2401 E 6th St, Austin, TX', dropoff_address: '11706 Argonne Forest Trail, Austin, TX')

      # Ensure chauffeur and ride are created
      expect(chauffeur).to be_present
      expect(ride).to be_present

      # Calculate expected values using CalculatorService
      calculator = CalculatorService.new
      commute = calculator.calculate_route_metrics(chauffeur.home_address, ride.pickup_address)

      # puts "GINASAURUS TripSpec.create_trip_by_ids: commute: #{commute}"



      commute[:miles] = commute[:miles].round(2)
      commute[:minutes] = commute[:minutes].round(2)



      totals = calculator.calculate_totals(commute, { miles: ride.ride_miles, minutes: ride.ride_minutes })
      score = calculator.calculate_score(ride.ride_earnings, totals[:total_miles]).round(2)

      # Create the trip using real results from CalculatorService
      trip = Trip.create_trip_by_ids(chauffeur.id, ride.id)
      trip.score = trip.score.round(2)

      # Debugging output to check trip creation
      puts "Trip errors: #{trip.errors.full_messages}" unless trip.persisted?
      expect(trip).to be_persisted

      # trips = Trip.all
      # trips.each_with_index do |trip, index|
      #   puts "TRIP Trip #{index + 1}: ID: #{trip.id}"
      #   puts "chauffeur_id: #{trip.chauffeur_id}"
      #   puts "ride_id: #{trip.ride_id}"
      #   puts "commute_minutes: #{trip.commute_minutes}"
      #   puts "total_minutes: #{trip.total_minutes}"
      #   puts "score: #{trip.score}"
      #   puts "======================\n"
      # end


      # Expect the trip attributes to match the calculated values
      expect(trip.chauffeur_id).to eq(chauffeur.id)
      expect(trip.id).to start_with('t') # for the callback
      expect(trip.ride_id).to eq(ride.id)
      expect(trip.commute_minutes).to eq(commute[:minutes])
      expect(trip.commute_miles).to eq(commute[:miles])
      expect(trip.total_hours).to eq(totals[:total_hours])
      expect(trip.total_minutes).to eq(totals[:total_minutes])
      expect(trip.total_miles).to eq(totals[:total_miles])
      expect(trip.earnings).to eq(ride.ride_earnings)
      expect(trip.score).to eq(score)
    end
  end

end
