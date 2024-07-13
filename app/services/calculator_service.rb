# app/services/calculator_service.rb
class CalculatorService

  def initialize(user_driver, ride)
    @user_driver = user_driver
    @ride = ride
    @gmap = GoogleMapService.new
  end

  # Calculate earnings based on distance and duration of the Ride: base + distance_earnings + duration_earnings
  # $12 + ($1.50 * (ride distance - 5 miles)) + ($0.70 * (ride duration - 15 min))
  def calculate_earnings(totals_result)
    base = 12.00

    earn_miles = (totals_result[:total_miles] - 5).round(2)
    earn_minutes = (totals_result[:total_minutes] - 15).round(2)

    distance_earnings = earn_miles * 1.5
    duration_earnings = earn_minutes * 0.70

    earnings = base + distance_earnings + duration_earnings
    earnings.round(2)
  end

  # From Driver's home to Ride Pickup to Ride Destination
  def calculate_totals(commute_result)
    total_miles = (@ride.ride_miles + commute_result[:commute_miles]).round(2)
    total_minutes = (@ride.ride_minutes + commute_result[:commute_minutes]).round(2)
    total_hours = total_minutes / 60.0

    {
      total_miles: total_miles,
      total_minutes: total_minutes,
      total_hours: total_hours
    }
  end

  # Driver's home to Ride's pickup
  def calculate_commute
    commute_route = @gmap.get_route_info(@user_driver.home_address, @ride.pickup_address)
    commute_hours = commute_route[:minutes] / 60.0
    {
      commute_miles: commute_route[:miles],
      commute_minutes: commute_route[:minutes],
      commute_hours: commute_hours
    }
  end

end
