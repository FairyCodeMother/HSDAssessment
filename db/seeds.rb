# db/seeds.rb

# Destroy existing records to prevent duplication
Driver.destroy_all
Ride.destroy_all

# Create some drivers
driver1 = Driver.create!(home_address: '123 Main St, Anytown, USA')
driver2 = Driver.create!(home_address: '456 Oak St, Sometown, USA')
driver3 = Driver.create!(home_address: '789 Pine St, Yourtown, USA')

# Create some rides
Ride.create!(
  start_address: '100 Elm St, Anothertown, USA', 
  destination_address: '200 Maple St, Differenttown, USA', 
  ride_distance_miles: 15.0, 
  ride_duration_hours: 0.5,
  created_at: Time.now
)

Ride.create!(
  start_address: '150 Elm St, Anothertown, USA', 
  destination_address: '250 Maple St, Differenttown, USA', 
  ride_distance_miles: 20.0, 
  ride_duration_hours: 0.75,
  created_at: Time.now
)

Ride.create!(
  start_address: '200 Elm St, Anothertown, USA', 
  destination_address: '300 Maple St, Differenttown, USA', 
  ride_distance_miles: 25.0, 
  ride_duration_hours: 1.0,
  created_at: Time.now
)

Ride.create!(
  start_address: '250 Elm St, Anothertown, USA', 
  destination_address: '350 Maple St, Differenttown, USA', 
  ride_distance_miles: 30.0, 
  ride_duration_hours: 1.25,
  created_at: Time.now
)

puts "Seeded #{Driver.count} drivers and #{Ride.count} rides."
