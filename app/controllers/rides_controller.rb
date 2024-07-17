# app/controllers/rides_controller.rb
class RidesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_ride, only: [:show, :update, :destroy]

  # POST /rides
  def create
    calculator = CalculatorService.new
    pickup = ride_params[:pickup_address]
    dropoff = ride_params[:dropoff_address]
    # puts "[GINASAURUS] New Ride: pickup_address: #{pickup}, dropoff_address: #{dropoff}"

    # Validate params
    if invalid_ride_params?(ride_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

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

    @ride = Ride.new(
      pickup_address: pickup,
      dropoff_address: dropoff,
      ride_miles: ride_miles,
      ride_minutes: ride_minutes,
      ride_earnings: ride_earnings
    )

    if @ride.save
      render json: @ride, status: :created
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rides/:id
  def destroy
    @ride.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Trip not found." }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /rides
  def index
    @all_rides = Ride.all
    render json: @all_rides
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /rides/:id
  def show
    render json: @ride
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
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

  def invalid_ride_params?(params)
    params.values.any?(&:blank?)
  end

  def ride_params
    params.require(:ride).permit(:pickup_address, :dropoff_address)
  end

  def set_ride
    @ride = Ride.find_by(id: params[:id])
    render json: { error: 'Ride not found' }, status: :not_found if @ride.nil?
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Ride not found' }, status: :not_found
  end


end
