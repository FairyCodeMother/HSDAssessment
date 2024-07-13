# app/services/google_map_service.rb
require 'google-maps'

# Manages interactions/business logic with the Google Matrix API (all distance/time calculations)
class GoogleMapService

  def initialize(api_key = ENV['GOOGLE_MAPS_API_KEY'])
    @api_key = api_key
  end

  # Retrieve both route miles and duration in one call
  def get_route_info(origin, destination)
    puts "{GINASAURUS} route_info: origin: #{origin}"
    {
      miles: get_route_miles(origin, destination),
      minutes: get_route_minutes(origin, destination)
    }
  end

  private

  # Fetch route miles using Google Maps API
  def get_route_miles(origin, destination)
    route_miles = Google::Maps.distance(origin, destination).to_f.round(2)
    puts "{GINASAURUS} route_miles: origin: #{route_miles}"
    route_miles
  rescue StandardError => e
    handle_error(e)
  end

  # Fetch route duration using Google Maps API
  def get_route_minutes(origin, destination)
    route_minutes = Google::Maps.duration(origin, destination).to_f.round(2)
    puts "{GINASAURUS} route_minutes: origin: #{route_minutes}"
    route_minutes
  rescue StandardError => e
    handle_error(e)
  end

  def handle_error(exception)
    Rails.logger.error "\n\n[ERROR] Google Maps API error: #{exception.message}"
    { error: "API error: #{exception.message}" }
  end
end
