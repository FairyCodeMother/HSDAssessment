# app/services/google_directions_service.rb
require 'google_maps_service'

# Manages interactions/business logic with the Google Directions API (all distance/time calculations)
class GoogleDirectionsService

  def initialize(api_key = ENV['GOOGLE_MAPS_API_KEY'])
    @gmaps = GoogleMapsService::Client.new(key: api_key)
  end

  # calculates distance between two points
  def get_distance_miles(origins, destinations)
    result = get_distance_matrix(origins, destinations)
    distance = result[:rows][0][:elements][0][:distance][:value]

    distance_miles = distance/1609.34 # Convert meters to miles
    distance_miles
  end

  # calculates duration between two points
  def get_duration_hours(origins, destinations)
    result = get_distance_matrix(origins, destinations)
    duration = result[:rows][0][:elements][0][:duration][:value]

    duration_hours = duration/3600.0 # Convert seconds to hours    
    duration_hours
  end
  
  # Multiple parameters distance matrix
  def get_distance_matrix(origins, destinations)
    # origins = ["Bobcaygeon ON", [41.43206, -81.38992]]
    # destinations = [[43.012486, -83.6964149], {lat: 42.8863855, lng: -78.8781627}]

    @gmaps.distance_matrix(origins, destinations, mode: 'driving')
  end

end

# https://developers.google.com/maps/documentation/distance-matrix
# https://github.com/edwardsamuel/google-maps-services-ruby
# https://github.com/edwardsamuel/google-maps-services-ruby/blob/master/spec/google_maps_service/apis/distance_matrix_spec.rb