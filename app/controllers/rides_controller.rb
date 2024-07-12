# app/controllers/rides_controller.rb
class RidesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_ride, only: [:show, :update, :destroy]

  # POST /rides
  def create
    origin = ride_params[:pickup_address]
    destination = ride_params[:destination_address]

    gmap = GoogleMapService.new
    ride_miles = gmap.get_route_miles(origin, destination)
    ride_minutes = gmap.get_route_minutes(origin, destination)
    # result = gmap.get_map_matrix(origin, destination)
    # ride_miles = (result[:distance].to_f).round(2) # miles
    # ride_minutes = (result[:duration].to_f).round(2) # minutes
    puts "+++++++++++++++++++++++++++++++++++"
    puts "[RidesController] create: #{ride_miles} mi, #{ride_minutes} min"
    puts "+++++++++++++++++++++++++++++++++++"

    @ride = Ride.new(
      pickup_address: origin,
      destination_address: destination,
      ride_miles: ride_miles,
      ride_minutes: ride_minutes
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

  # DONE- GET /rides
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

  # DONE
  def set_ride
    @ride = Ride.find_by(id: params[:id])
    if @ride.nil?
      render json: { error: 'Ride not found' }, status: :not_found
    end
  end

  # ride_params = {
  #   "pickup_address": "100 Congress Ave, Austin, TX, 78701",
  #   "destination_address": "501 West 6th St, Austin, TX, 78701"
  # }
  def ride_params
    params.require(:ride).permit(:pickup_address, :destination_address)
  end

end
