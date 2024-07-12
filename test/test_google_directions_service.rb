# test/test_google_directions_service.rb
# ruby test/test_google_directions_service.rb

require_relative '../app/services/google_directions_service'
require 'dotenv/load'

# Initialize the service
puts "[TEST] Environment variables (.env): #{ENV.inspect}\n\n..."

service = GoogleDirectionsService.new

# origins = ['New York, NY']
origins = ["Bobcaygeon ON", [41.43206, -81.38992]]

# destinations = ['Los Angeles, CA']
destinations = [[43.012486, -83.6964149], {lat: 42.8863855, lng: -78.8781627}]

# Test the get_distance_miles method
distance = service.get_distance_miles(origins, destinations)
puts "[TEST] Distance: #{distance} miles\n..."

# Test the get_duration_hours method
duration = service.get_duration_hours(origins, destinations)
puts "[TEST] Duration: #{duration} hours\n..."