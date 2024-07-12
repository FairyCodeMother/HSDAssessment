# app/controllers/drivers_controller.rb
class DriversController < ApplicationController

  # GET /drivers
  def index
    @all_drivers = Driver.all
    render json @all_drivers
  end

  # GET /drivers/:id
  def show
    render json: @driver
  end

  # POST /drivers
  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      render json: @driver, status: :created, location: @driver
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drivers/:id
  def update
    if @driver.update(driver_params)
      render json: @driver
    else
      render json: @driver.errors, status: :unprocessable_entity
    end
  end

  # DELETE /drivers/:id
  def destroy
    @driver.destroy
    head :no_content
  end

  # Returns a paginated JSON list of rides in descending score order for a given driver
  # Calculate the score of a Trip (ride in $ per hour as: (ride earnings) / (commute duration + ride duration))
  # GET /rides/get_trips_by_driver
  def get_trips_by_driver_id

    puts "------------------------------------------------"
    puts "[DriversController] get_trips_by_driver_id: ID #{params[:id]}"
    puts "------------------------------------------------"

    user_driver = Driver.order('RANDOM()').first # Driver.find(params[:id])

    driver_rides = user_driver.get_all_driver_rides

    trip_list = driver_rides.map do |ride|

      calculator = CalculatorService.new(user_driver, ride)
      commute_result = calculator.calculate_commute
      totals_result = calculator.calculate_totals(commute_result)

      puts "[DriversController] totals: #{totals_result[:total_miles]} mi"

      earnings = calculator.calculate_earnings
      puts "[DriversController] earnings: #{earnings}"

      new_trip = Trip.create!(
        driver_id: user_driver.id,
        ride_id: ride.id,
        commute_miles: commute_result[:commute_miles].to_f,
        commute_minutes: commute_result[:commute_minutes].to_f,
        total_miles: totals_result[:total_miles].to_f,
        total_minutes: totals_result[:total_minutes].to_f,
        total_hours: totals_result[:total_minutes].to_f/60,
        earnings: earnings
      )
    end

    puts "\n\n[DriversController] trip_list: #{trip_list}"


    # Sort the Rides desc: Higher is better!
    trip_list.sort_by{ |trip| trip.earnings }.reverse
    puts "\n\n[DriversController] trip_list: #{trip_list}"

    render json: trip_list, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Driver not found' }, status: :not_found
  rescue ActiveRecord::StatementInvalid => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def driver_params
    params.require(:driver).permit(:name, :home_address)
  end


end
