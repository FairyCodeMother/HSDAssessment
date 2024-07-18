# app/controllers/rides_controller.rb
class RidesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_ride, only: [:show, :update, :destroy]

  # POST /rides
  def create
    calculator = CalculatorService.new
    pickup = ride_params[:pickup_address]
    dropoff = ride_params[:dropoff_address]

    if invalid_ride_params?(ride_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    # Address validations go here (eg. geocodable, "correct" format, within ranges, etc)
    # unless valid_address?(pickup) && valid_address?(dropoff)
    #   render json: { error: 'Invalid or unrecognizable addresses' }, status: :bad_request
    #   return
    # end

    # Calculate ride metrics
    ride_info = calculator.calculate_route_metrics(pickup, dropoff)
    if ride_info.nil? || ride_info[:miles].nil? || ride_info[:minutes].nil?
      render json: { error: 'Unable to calculate ride metrics' }, status: :unprocessable_entity
      return
    end

    # Calculate ride earnings
    ride_earnings = calculator.calculate_earnings(ride_info[:miles], ride_info[:minutes])
    if ride_earnings.nil?
      render json: { error: 'Unable to calculate ride earnings' }, status: :unprocessable_entity
      return
    end

    @ride = Ride.new(
      pickup_address: pickup,
      dropoff_address: dropoff,
      ride_miles: ride_info[:miles],
      ride_minutes: ride_info[:minutes],
      ride_earnings: ride_earnings
    )
    if @ride.save
      render json: @ride, status: :created
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # DELETE /rides/:id
  def destroy
    @ride.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Ride not found' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /rides
  # Would normally add pagination
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
    if invalid_ride_params?(ride_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    if @ride.update(ride_params)
      render json: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
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
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Ride not found' }, status: :not_found
  end

  # Add logic to verify if an address is valid and geocodable
  # This could involve a regex check or an API call to a geocoding service
  # def valid_address?(address)
  #   address.present? && address.match?(/\A\d+ .+, .+, [A-Z]{2} \d{5}\z/)
  # end

end
