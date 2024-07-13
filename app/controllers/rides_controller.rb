# app/controllers/rides_controller.rb
class RidesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_ride, only: [:show, :update, :destroy]

  # POST /rides
  def create
    origin = ride_params[:pickup_address]
    destination = ride_params[:destination_address]
    puts "{GINASAURUS} ride params: #{ride_params[:pickup_address]}"

    gmap = GoogleMapService.new
    route_info = gmap.get_route_info(origin, destination)
    puts "{GINASAURUS} ride ride_miles: #{route_info[:minutes]}"

    @ride = Ride.new(
      pickup_address: origin,
      destination_address: destination,
      ride_miles: route_info[:miles],
      ride_minutes: route_info[:minutes]
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
  end

  # GET /rides
  def index
    @all_rides = Ride.all
    render json: @all_rides
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
    params.require(:ride).permit(:pickup_address, :destination_address)
  end
end
