# app/models/trip_calculator.rb
class TripCalculator
  def initialize(service = GoogleDirectionsService.new)
    @service = service
  end

  # Total drive distance, from Driver's home to Ride Destination
  def calculate_trip_distance(home_address, start_address, destination_address)
    commute_distance = @service.get_distance_miles([home_address], [start_address])
    ride_distance = @service.get_distance_miles([start_address], [destination_address])
    total_distance = commute_distance + ride_distance

    {
      commute_distance: commute_distance,
      ride_distance: ride_distance,
      total_distance: total_distance
    }
  end

  # Total drive time, from Driver's home to Ride Destination
  def calculate_trip_duration(home_address, start_address, destination_address)
    commute_duration = @service.get_duration_hours([home_address], [start_address])
    ride_duration = @service.get_duration_hours([start_address], [destination_address])
    total_duration = commute_duration + ride_duration

    {
      commute_duration: commute_duration,
      ride_duration: ride_duration,
      total_duration: total_duration
    }
  end

end