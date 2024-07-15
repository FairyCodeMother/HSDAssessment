# app/models/trip.rb

# A Trip consists of:
#   - Driver's commute: distance/duration (Driver's home_address to Ride's start_address)
#   - Ride: distance/duration (Ride's start_address to Ride's dropoff_address)
class Trip < ApplicationRecord
  belongs_to :chauffeur
  belongs_to :ride

  validates :chauffeur_id, :ride_id, presence: true
  validates :commute_minutes, :commute_miles, :total_hours, :total_minutes, :total_miles, :score, presence: true, numericality: { greater_than: 0 }

  self.primary_key = 'id'

  # Set Trip ID before creation if blank
  before_create :set_trip_id

  def self.create_trip_by_ids(chauffeur_id, ride_id)
    # Fetch Chauffeur and Ride
    chauffeur = Chauffeur.find(chauffeur_id)
    ride = Ride.find(ride_id)
    ride_earnings = ride.ride_earnings

    puts "[GINASAURUS] TRIP: chauffeur_id: #{chauffeur.id}, ride_id: #{ride.id}, ride_earnings: #{ride_earnings}."

    # Calculate commute: Chauffeur's home_address to Ride's pickup_address
    commute = calculate_trip_commute(chauffeur.home_address, ride.pickup_address)
    puts "[GINASAURUS] TRIP: commute: #{commute[:minutes]} mins, #{commute[:miles]} mi."

    # Calculate totals: Chauffeur's home_address to Ride's pickup_address to Ride's dropoff_address
    totals = calculate_trip_totals(commute, ride)
    puts "[GINASAURUS] TRIP: totals: #{totals[:total_minutes]} mins, #{totals[:total_miles]} mi."

    # Calculate score
    score = calculate_trip_score(ride.ride_earnings, totals[:total_miles])

    # Create the Trip
    @trip = Trip.create!(
      chauffeur_id: chauffeur_id,
      ride_id: ride_id,
      commute_minutes: commute[:minutes],
      commute_miles: commute[:miles],
      total_hours: totals[:total_hours],
      total_minutes: totals[:total_minutes],
      total_miles: totals[:total_miles],
      earnings: ride.ride_earnings,
      score: score
    )
    puts "[GINASAURUS] TRIP New Trip:"
    puts "    chauffeur_id: #{@trip.chauffeur_id}, ride_id: #{@trip.ride_id}"
    puts "    commute: #{@trip.commute_miles} mi, #{@trip.commute_minutes} mins"
    puts "    total: #{@trip.total_miles} mi, #{@trip.total_minutes} hrs, #{@trip.total_hours} mins"
    puts "    earnings: #{@trip.earnings}, score: #{@trip.score}"
    puts " ====================  "

    @trip
  end

  private

  def self.calculate_trip_commute(home_address, pickup_address)
    calculator = CalculatorService.new
    calculator.calculate_route_metrics(home_address, pickup_address)
  end

  def self.calculate_trip_totals(commute_result, ride)
    calculator = CalculatorService.new
    ride_values = { miles: ride.ride_miles, minutes: ride.ride_minutes }
    calculator.calculate_totals(commute_result, ride_values)
  end

  def self.calculate_trip_score(ride_earnings, total_miles)
    calculator = CalculatorService.new
    calculator.calculate_score(ride_earnings, total_miles)
  end

  # Custom key starts with "t"
  def set_trip_id
    self.id = "t#{SecureRandom.uuid}" if id.blank?
  end
end
