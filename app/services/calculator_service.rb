# app/services/calculator_service.rb
class CalculatorService

  def initialize(driver, ride)
    @gmap = GoogleMapService.new
    @d_home_address = driver.home_address
    @r_pickup_address = ride.pickup_address
    @r_destination_address = ride.destination_address
    @r_miles = ride.ride_miles.to_f
    @r_minutes = ride.ride_minutes
    puts "[CalculatorSvc] initialize- ride: #{@r_miles} mi, #{@r_minutes} min"
  end

  # Amount Driver earns if they choose the Ride: base + distance_earnings + duration_earnings
  # $12 + ($1.50 * (ride distance - 5 miles)) + ($0.70 * (ride duration - 15 min))
  def calculate_earnings
    base = 12.00

    puts "::::::: #{@t_miles} mi ::::::: #{@t_minutes} min :::::::::"
    puts ":::::::::::::::::::::::::::::::::::::"

    earn_miles = (@t_miles - 5).round(2)
    per_mile = 1.5
    distance_earnings = earn_miles * per_mile
    puts "[CalculatorSvc] earnings- earn_miles: #{earn_miles} mi * #{per_mile} = $#{(earn_miles * per_mile).round(2) } distance."

    earn_minutes = (@t_minutes - 15).round(2)
    per_min = 0.70
    duration_earnings = earn_minutes * per_min
    puts "[CalculatorSvc] earnings- earn_minutes: #{earn_minutes} min * #{per_min} = $#{earn_minutes * per_min } duration."

    earnings = base + distance_earnings + duration_earnings

    puts "[CalculatorSvc] earnings- earnings: $#{earnings} totals."
    earnings
  end

  # From Driver's home to Ride Destination
  def calculate_totals(commute_result)
    @c_miles = commute_result[:commute_miles]
    @c_minutes = commute_result[:commute_minutes]

    @t_miles = (@c_miles + @r_miles).round(2)
    @t_minutes = (@c_minutes + @r_minutes).round(2)

    puts "------------------------------------------------"
    puts "[CalculatorSvc] calculate_totals: #{@t_miles} mi, #{@t_minutes} min: CORRECT"
    puts "------------------------------------------------"

    totals = {
      total_miles: @t_miles.to_f,
      total_minutes: @t_minutes.to_f,
      total_hours: @t_minutes.to_f/60
    }
  end

  # Driver's home to Ride's pickup
  def calculate_commute
    # commute = @gmap.get_miles_matrix(@d_home_address, @r_pickup_address)
    c_miles = @gmap.get_route_miles(@d_home_address, @r_pickup_address) # commute[:distance] # miles
    c_minutes = @gmap.get_route_minutes(@d_home_address, @r_pickup_address) # commute[:duration] # min

    puts "[CalculatorSvc] calculate_commute- commute: #{c_miles} mi, #{c_minutes} min"

    commute = {
      commute_miles: c_miles,
      commute_minutes: c_minutes,
      commute_hours: @t_minutes.to_f/60
    }
  end

end
