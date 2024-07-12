# app/services/google_map_service.rb
require 'google-maps'

# Manages interactions/business logic with the Google Matrix API (all distance/time calculations)
class GoogleMapService

  def initialize(api_key = ENV['GOOGLE_MAPS_API_KEY'])
    @api_key = api_key
  end

  def get_route_miles(origin, destination)
    miles = Google::Maps.distance(origin, destination).to_f # miles
    puts "==== [GoogleMapService] Miles: #{miles} mi ===="

    (miles.to_f).round(2)
  rescue StandardError => e
    handle_error(e)
  end

  def get_route_minutes(origin, destination)
    minutes = Google::Maps.duration(origin, destination).to_f # minutes
    puts "==== [GoogleMapService] Minutes: #{minutes} mins ===="

    (minutes.to_f).round(2)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def handle_error(exception)
    Rails.logger.error "\n\n[ERROR] Google Maps API error: #{exception.message}"
    { error: "API error: #{exception.message}" }
  end

end
