# db/seeds.rb
# docker-compose run web rails db:seed

# Clear existing data
UserDriver.destroy_all
Ride.destroy_all

# Seed Drivers: IDs auto generated
user_drivers = [
  { home_address: '100 Congress Ave, Austin, TX' },
  { home_address: '501 West 6th St, Austin, TX' },
  { home_address: '1201 S Lamar Blvd, Austin, TX' },
  { home_address: '2200 S IH 35 Frontage Rd, Austin, TX' },
  { home_address: '2120 Guadalupe St, Austin, TX' },
]
user_drivers.each do |user_driver|
  UserDriver.create!(user_driver)
end

# Seed Rides: IDs auto generated, distances/durations calculated dynamically
rides = [
  { pickup_address: '2401 E 6th St, Austin, TX', destination_address: '11711 Argonne Forst Trail, Austin, TX' },
  { pickup_address: '4700 West Guadalupe, Austin, TX', destination_address: '3600 Presidential Blvd, Austin, TX'},
  { pickup_address: '4000 S IH 35 Frontage Rd, Austin, TX', destination_address: '3107 E 14th 1/2 St, Austin, TX' },
  { pickup_address: '2325 San Antonio St, Austin, TX', destination_address: '2001 E Cesar Chavez St, Austin, TX' }
]

@gmap_service = GoogleMapService.new

rides.each do |ride_data|
  origin = ride_data[:pickup_address]
  destination = ride_data[:destination_address]

  route_info = @gmap_service.get_route_info(origin, destination)

  ride_params = {
    pickup_address: origin,
    destination_address: destination,
    ride_minutes: route_info[:minutes],
    ride_miles: route_info[:miles]
  }
  Ride.create!(ride_params)
end

puts "Seed data created successfully!"
