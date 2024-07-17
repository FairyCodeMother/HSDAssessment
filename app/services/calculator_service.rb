# app/services/calculator_service.rb
class CalculatorService

  def initialize
    @gmap = GoogleMapService.new
  end

  # Calculate earnings based on distance and duration of the Ride: base + distance_earnings + duration_earnings
  # $12 + ($1.50 * (ride distance - 5 miles)) + ($0.70 * (ride duration - 15 min))
  def calculate_earnings(ride_miles, ride_minutes)
    base = 12.00

    earn_miles = (ride_miles - 5).round(2)
    earn_minutes = (ride_minutes - 15).round(2)

    distance_earnings = earn_miles * 1.5
    duration_earnings = earn_minutes * 0.70

    earnings = base + distance_earnings + duration_earnings
    earnings.round(2)
  end

  # Driver's home to Ride Pickup to Ride Destination: Only Trips have HOURS
  def calculate_totals(commute, ride_values)
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
    route_info = @gmap.get_route_info(starting_address, ending_address)

    # puts "GINASAURUS CalculatorService: route_info[:miles]: #{route_info[:miles]}."



    route_miles = route_info[:miles].round(2)
    route_minutes = route_info[:minutes].round(2)

    finished_route = {
      miles: route_miles,
      minutes: route_minutes
    }
    # puts "[GINASAURUS] CALCULATOR calculate_route_metrics: finished_route: #{finished_route}."
    finished_route
  end

  # Calculates score (and order) based on earnings divided by total distance (commute + ride distance)
  # (ride earnings) / (hourly commute duration + hourly ride duration). Higher is better
  def calculate_score(earnings, total_miles)
    earnings/(total_miles)
  end

end
