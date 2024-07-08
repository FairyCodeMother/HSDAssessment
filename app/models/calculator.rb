# app/models/calculator.rb
class Calculator
  def initialize(service = GoogleDirectionsService.new)
    @service = service
  end

  # Calculates time to drive from starting to ending addresses
  def calculate_duration(starting, ending)
    @service.get_duration_hours(starting, ending)
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

  # Calculates distance from starting to ending addresses
  def calculate_distance(starting, ending)
    @service.calculate_distance_miles(starting, ending)
  end

  # Total drive distance, from Driver's home to Ride Destination
  def calculate_trip_distance(home_address, start_address, destination_address)
    commute_distance = calculate_distance_miles([home_address], [start_address])
    ride_distance = calculate_distance_miles([start_address], [destination_address])
    total_distance = commute_distance + ride_distance

    {
      commute_distance: commute_distance,
      ride_distance: ride_distance,
      total_distance: total_distance
    }
  end
end