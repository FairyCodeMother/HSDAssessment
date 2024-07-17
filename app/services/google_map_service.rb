# app/services/google_map_service.rb
require 'google-maps'

# Manages interactions/business logic with the Google Matrix API (all distance/time calculations)
class GoogleMapService

  def initialize(api_key = ENV['GOOGLE_MAPS_API_KEY'])
    @api_key = api_key
  rescue StandardError => e
    handle_error(e)
  end

  # Accepts two addresses and fetches route distance and duration
  def get_route_info(origin, destination)
    # Return cached data if available: reduces API calls
    cached_data = get_cached_data(origin, destination)
    return cached_data if cached_data.present?

    miles = get_route_miles(origin, destination)
    minutes = get_route_minutes(origin, destination)

    # Otherwise, make API calls and store the results in the cache
    route_info = {
      miles: miles,
      minutes: minutes
    }

    # Store the result in cache for future use (e.g., 1 day)
    Rails.cache.write(@cache_key, route_info, expires_in: 1.day)

    # puts "[GINASAURUS] GMAP route_info: #{route_info}."
    route_info
  rescue StandardError => e
    handle_error(e)
  end

  # Group multiple requests into one API call: reduces API calls
  # NOT TESTED!!!
  def get_batch_route_info(queries)
    # queries must be array of hashes: [{origin: '...', destination: '...'}, ...]
    # puts "[GINASAURUS] GMAP get_batch_route_info: queries: #{queries}."

    # Unique cache key for each query; check if cached
    cache_results = {}
    queries.each do |query|
      cache_key = "route_info/#{query[:origin]}/#{query[:destination]}"
      # puts "[GINASAURUS] GMAP get_batch_route_info: cache_key: #{cache_key}."

      cached_data = Rails.cache.read(cache_key)
      if cached_data.present?
        cache_results[cache_key] = cached_data
        queries.delete(query) # Remove cached queries from fetched list
      end
    end

    # Fetch remaining uncached queries from Google
    if queries.any?
      batch_results = Google::Maps.batch_request(queries.map { |q| [q[:origin], q[:destination]] })
      batch_results.each_with_index do |result, index|
        origin = queries[index][:origin]
        destination = queries[index][:destination]
        route_info = { miles: result[:distance].to_f.round(2), minutes: result[:duration].to_f.round(2) }
        cache_key = "route_info/#{origin}/#{destination}"

        # Store in cache
        Rails.cache.write(cache_key, route_info, expires_in: 1.day)

        # Add to results
        cache_results[cache_key] = route_info
      end
    end

    # puts "[GINASAURUS] GMAP get_batch_route_info: cache_results: #{cache_results}."
    cache_results
  rescue StandardError => e
    handle_error(e)
  end

  private

  def get_cached_data(origin, destination)
    # Unique cache key based on origin and destination
    @cache_key = "route_info/#{origin}/#{destination}"

    # Attempt fetch
    Rails.cache.read(@cache_key)
  rescue StandardError => e
    handle_error(e)
  end

  # Fetch route miles using Google Maps API
  def get_route_miles(origin, destination)
    route_miles = Google::Maps.distance(origin, destination)

    route_miles.to_f.round(2)
  rescue StandardError => e
    handle_error(e)
  end

  # Fetch route duration using Google Maps API
  def get_route_minutes(origin, destination)
    route_minutes = Google::Maps.duration(origin, destination)

    route_minutes.to_f.round(2)
  rescue StandardError => e
    handle_error(e)
  end

  def handle_error(exception)
    Rails.logger.error "\n\n[ERROR] Google Maps API error: #{exception.message}"
    { error: "API error: #{exception.message}" }
  end
end
