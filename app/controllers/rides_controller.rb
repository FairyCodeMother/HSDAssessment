# app/controllers/rides_controller.rb
class RidesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_ride, only: [:show, :update, :destroy]

  # POST /rides
  def create
    # Setup
    calculator = CalculatorService.new
    pickup = ride_params[:pickup_address]
    dropoff = ride_params[:dropoff_address]
    # puts "[GINASAURUS] New Ride: pickup_address: #{pickup}, dropoff_address: #{dropoff}"

    # Ride pickup to dropoff locations
    route_info = calculator.calculate_route_metrics(pickup, dropoff)
    ride_miles = route_info[:miles]
    ride_minutes = route_info[:minutes]
    # puts "[GINASAURUS] New Ride: ride_miles: #{ride_miles}, ride_minutes: #{ride_minutes}"

    # $12 + ($1.50 * (ride distance - 5 miles)) + ($0.70 * (ride duration - 15 min))
    ride_earnings = calculator.calculate_earnings(
      route_info[:miles],
      route_info[:minutes]
    )
    # puts "[GINASAURUS] New Ride: ride_earnings: #{ride_earnings}"

    @ride = Ride.new(
      pickup_address: pickup,
      dropoff_address: dropoff,
      ride_miles: ride_miles,
      ride_minutes: ride_minutes,
      ride_earnings: ride_earnings
    )

    if @ride.save
      # puts "[GINASAURUS] New Ride:"
      # puts "    pickup_address: #{pickup_address}"
      # puts "    dropoff_address: #{dropoff_address}"
      # puts "    ride_miles: #{ride_miles}, ride_minutes: #{ride_minutes}"
      # puts "    ride_earnings: #{ride_earnings}"
      # puts " ====================  "
      render json: @ride, status: :created
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  # GET /rides
  def index
    @all_rides = Ride.all
    render json: @all_rides
  end

  # DELETE /rides/:id
  def destroy
    @ride.destroy
    head :no_content
  end

  # GET /rides/:id
  def show
    render json: @ride
  end

  # PUT /rides/:id
  def update
    if @ride.update(ride_params)
      render json: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  private

  def set_ride
    @ride = Ride.find_by(id: params[:id])
    render json: { error: 'Ride not found' }, status: :not_found if @ride.nil?
  end

  def ride_params
    params.require(:ride).permit(:pickup_address, :dropoff_address)
  end
end
