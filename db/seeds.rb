# db/seeds.rb
# docker-compose run web rails db:seed
require 'faker' # generate random data

# Clear existing data
Driver.destroy_all
Ride.destroy_all

# Seed Drivers: IDs auto generated
5.times do
  Driver.create!(
    home_address: Faker::Address.full_address
  )
end

# Seed Rides: IDs auto generated, distances/durations calculated dynamically
10.times do
  Ride.create!(
    starting_address: Faker::Address.full_address,
    destination_address: Faker::Address.full_address,
    ride_distance: nil,
    ride_duration: nil
  )
end

# Seed Trips: IDs auto generated, distances/durations calculated dynamically
Driver.all.each do |driver|
  ride = Ride.offset(rand(Ride.count)).first

  Trip.create!(
    ride: ride,
    driver: driver,
    commute_distance: nil,
    commute_duration: nil,
    total_distance: nil,
    total_duration: nil
  )
end

puts "Seed data created successfully!"
