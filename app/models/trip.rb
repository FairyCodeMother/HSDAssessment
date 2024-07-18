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

  # Create Trips for each Ride
  def self.create_trip_by_ids(chauffeur_id, ride_id)
    # Fetch Chauffeur and Ride, ensure they exist
    chauffeur = Chauffeur.find(chauffeur_id)
    ride = Ride.find(ride_id)
    ride_earnings = ride.ride_earnings

    commute = calculate_trip_commute(chauffeur.home_address, ride.pickup_address)
    totals = calculate_trip_totals(commute, ride)
    score = calculate_trip_score(ride.ride_earnings, totals[:total_miles])

    @trip = Trip.create!(
      chauffeur_id: chauffeur_id,
      ride_id: ride_id,
      commute_minutes: commute[:minutes],
      commute_miles: commute[:miles],
      total_hours: totals[:total_hours],
      total_minutes: totals[:total_minutes],
      total_miles: totals[:total_miles],
      earnings: ride_earnings,
      score: score
    )
  rescue ActiveRecord::RecordNotFound => e
    raise "Chauffeur or Ride not found: #{e.message}"
  rescue StandardError => e
    raise "Error creating Trip: #{e.message}"
  end

  private

  # Chauffeur's home_address to Ride's pickup_address
  def self.calculate_trip_commute(home_address, pickup_address)
    calculator = CalculatorService.new
    calculator.calculate_route_metrics(home_address, pickup_address)
  end

  # Chauffeur's home_address to Ride's pickup_address to Ride's dropoff_address
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
