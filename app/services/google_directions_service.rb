# app/services/google_directions_service.rb
require 'google_maps_service'

class GoogleDirectionsService
  def initialize(api_key = ENV['GOOGLE_MAPS_API_KEY'])
    @gmaps = GoogleMapsService::Client.new(key: api_key)
  end

  def driving_distance(start_address, end_address)
    route = get_route(start_address, end_address)
    return unless route

    route[:legs][0][:distance][:value] / 1609.34 # Convert meters to miles
  end

  def driving_duration(start_address, end_address)
    route = get_route(start_address, end_address)
    return unless route

    route[:legs][0][:duration][:value] / 3600.0 # Convert seconds to hours
  end

  private

  def get_route(start_address, end_address)
    routes = @gmaps.directions(
      start_address,
      end_address,
      mode: 'driving',
      alternatives: false
    )
    routes.first
  end
end
