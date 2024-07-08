# Clear existing data
Driver.destroy_all
Ride.destroy_all

# Seed Drivers
# Uses Faker::Address.full_address to generate random home addresses.
# Automatically generates driver_id due to ActiveRecord.
5.times do
  Driver.create!(
    home_address: Faker::Address.full_address
  )
end

# Seed Rides
# Uses Faker::Address.full_address to generate random start and destination addresses.
# ride_distance_miles and ride_duration_hours are left as nil in the seed data because they will be calculated dynamically by your service object or background job
10.times do
  start_address = Faker::Address.full_address
  destination_address = Faker::Address.full_address
  ride_distance_miles = nil  # This will be calculated dynamically
  ride_duration_hours = nil  # This will be calculated dynamically

  Ride.create!(
    start_address: start_address,
    destination_address: destination_address,
    ride_distance_miles: ride_distance_miles,
    ride_duration_hours: ride_duration_hours
  )
end

# Output confirmation
puts "Seed data created successfully."
