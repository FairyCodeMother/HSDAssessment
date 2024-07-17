# db/seeds.rb
# docker-compose run web rails db:seed

# Clear existing data
Chauffeur.destroy_all
Ride.destroy_all
Trip.destroy_all

# Seed Chauffeurs: IDs are auto generated
chauffeurs = [
  { home_address: '501 West 6th St, Austin, TX' },
  { home_address: '1201 S Lamar Blvd, Austin, TX' },
  { home_address: '11711 Argonne Forest Trail, Austin, TX' },
  { home_address: '2200 S IH 35 Frontage Rd, Austin, TX' },
  { home_address: '5801 Burnet Rd, Austin, TX' },
]
chauffeurs.each do |chauffeur|
  new_chauffeur = Chauffeur.create!(chauffeur)
  # puts "[GINASAURUS] SEED Chauffeur: #{new_chauffeur.id} ID."

end

# Seed Rides: IDs are auto generated, distances/durations/earnings are calculated dynamically
rides = [
  { pickup_address: '2401 E 6th St, Austin, TX', dropoff_address: '11706 Argonne Forest Trail, Austin, TX' },
  { pickup_address: '4700 West Guadalupe, Austin, TX', dropoff_address: '3600 Presidential Blvd, Austin, TX'},
  { pickup_address: '156 W Cesar Chavez St, Austin, TX', dropoff_address: '3107 E 14th 1/2 St, Austin, TX' },
  { pickup_address: '2325 San Antonio St, Austin, TX', dropoff_address: '4000 S IH 35 Frontage Rd, Austin, TX' }
]

calculator = CalculatorService.new

rides.each do |ride_data|
  pickup_address = ride_data[:pickup_address]
  dropoff_address = ride_data[:dropoff_address]

  # Calculate route metrics
  route_info = calculator.calculate_route_metrics(pickup_address, dropoff_address)

  # Calculate earnings
  ride_earnings = calculator.calculate_earnings(route_info[:miles], route_info[:minutes])

  # puts "[GINASAURUS] SEED Ride: #{route_info[:miles]} miles, #{route_info[:minutes]} minutes, earnings: $ #{ride_earnings}."

  ride_params = {
    pickup_address: pickup_address,
    dropoff_address: dropoff_address,
    ride_miles: route_info[:miles],
    ride_minutes: route_info[:minutes],
    ride_earnings: ride_earnings
  }

  Ride.create!(ride_params)
end

# Seed a single Trip with a random Chauffeur and Ride
random_chauffeur = Chauffeur.order('RANDOM()').first
random_ride = Ride.order('RANDOM()').first

# Create the Trip
trip = Trip.create_trip_by_ids(random_chauffeur.id, random_ride.id)

# puts "[GINASAURUS] SEED Trip: chauffeur_id: #{trip.chauffeur_id}, ride_id: #{trip.ride_id}, score: #{trip.score}."

puts "All seed data created!"
