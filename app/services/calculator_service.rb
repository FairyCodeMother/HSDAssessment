# app/services/calculator_service.rb
class CalculatorService

  def initialize
    @gmap = GoogleMapService.new
  end

  # Calculate earnings based on distance and duration of Ride:
  # $12 + ($1.50 * (ride distance - 5 miles)) + ($0.70 * (ride duration - 15 min))
  def calculate_earnings(ride_miles, ride_minutes)
    validate_number(ride_miles)
    validate_number(ride_minutes)

    base = 12.00
    earn_miles = (ride_miles - 5).round(2)
    earn_minutes = (ride_minutes - 15).round(2)
    distance_earnings = earn_miles * 1.5
    duration_earnings = earn_minutes * 0.70

    (base + distance_earnings + duration_earnings).round(2)
  end

  # Driver's home to Ride Pickup to Ride Destination: Only Trips have HOURS
  def calculate_totals(commute, ride_values)
    validate_number(commute[:miles])
    validate_number(commute[:minutes])
    validate_number(ride_values[:miles])
    validate_number(ride_values[:minutes])

    total_miles = (commute[:miles] + ride_values[:miles]).round(2)
    total_minutes = (commute[:minutes] + ride_values[:minutes]).round(2)
    total_hours = (total_minutes / 60.0).round(2)

    {
      total_miles: total_miles,
      total_minutes: total_minutes,
      total_hours: total_hours
    }
  end

  # A route's starting location to destination location
  def calculate_route_metrics(starting_address, ending_address)
    validate_args(starting_address)
    validate_args(ending_address)

    route_info = @gmap.get_route_info(starting_address, ending_address)

    route_miles = route_info[:miles]
    route_minutes = route_info[:minutes]

    {
      miles: route_miles.round(2),
      minutes: route_minutes.round(2)
    }
  end

  # Based on earnings divided by total distance. Used for sorting: Higher is better
  # (ride earnings) / (hourly commute duration + hourly ride duration).
  def calculate_score(earnings, total_miles)
    validate_number(earnings)
    validate_number(total_miles)

    (earnings/(total_miles)).round(2)
  end

  private

  # Validate that arguments are not empty or nil
  def validate_args(*args)
    args.each do |arg|
      raise ArgumentError, "Argument cannot be empty or nil" if arg.nil? || (arg.respond_to?(:empty?) && arg.empty?)
    end
  end

  # Validate that argument is a number and >= 0
  def validate_number(arg)
    raise ArgumentError, "Argument must be a number and >= 0" unless arg.is_a?(Numeric) && arg >= 0
  end

end
