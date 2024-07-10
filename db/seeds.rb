# db/seeds.rb
# docker-compose run web rails db:seed
require 'faker' # generate random data

# Clear existing data
Driver.destroy_all
Ride.destroy_all

# Seed Drivers: IDs auto generated
drivers = [
  { name: 'John Doe', home_address: '123 Elm Street, Austin, TX' },
  { name: 'Jane Smith', home_address: '456 Oak Avenue, Dallas, TX' },
  { name: 'John Doe', home_address: '123 Main St, Chicago, IL' },
  { name: 'Jane Smith', home_address: '456 Elm St, San Francisco, CA' },
  { name: 'Michael Johnson', home_address: '789 Oak Ave, Detroit, MI' }
]
drivers.each { |driver| Driver.create!(driver) }

# Seed Rides: IDs auto generated, distances/durations calculated dynamically
rides = [
  { pickup_address: '789 Maple Drive', destination_address: '101 Pine Lane', ride_duration: 1.5, ride_distance: 10.0 },
  { pickup_address: '202 Birch Boulevard', destination_address: '303 Cedar Court', ride_duration: 0.75, ride_distance: 5.5 },
  { pickup_address: '100 First Ave', destination_address: '200 Second St', ride_distance: 10, ride_duration: 1 },
  { pickup_address: '300 Third Blvd', destination_address: '400 Fourth Dr', ride_distance: 7, ride_duration: 0.5 }
]
rides.each { |ride| Ride.create!(ride) }

# Seed Trips: IDs auto generated
# trips = [
#   { driver_id: 'd1', ride_id: 'r1', commute_duration: 0.25, commute_distance: 2.0, total_duration: 1.75, total_distance: 12.0 },
#   { driver_id: 'd2', ride_id: 'r2', commute_duration: 0.5, commute_distance: 3.0, total_duration: 1.25, total_distance: 8.5 },
#   { driver_id: 'd3', ride_id: 'r3', commute_duration: 0.8, commute_distance: 2.2, total_duration: 1.75, total_distance: 12.0 },
#   { driver_id: 'd4', ride_id: 'r4', commute_duration: 0.4, commute_distance: 1.4, total_duration: 1.4, total_distance: 8.5 }
# ]
# trips.each { |trip| Trip.create!(trip) }

puts "Seed data created successfully!"
