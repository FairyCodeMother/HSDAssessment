# app/controllers/trips_controller.rb
class TripsController < ApplicationController

  def create
    # Validate params
    if invalid_trip_params?(trip_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    chauffeur_id = trip_params[:chauffeur_id]
    ride_id = trip_params[:ride_id]
    # puts "GINASAURUS TripsController: Make Trip using: #{chauffeur_id} cID, #{ride_id} rID."

    @trip = Trip.create_trip_by_ids(chauffeur_id, ride_id)
    if @trip.save
      # puts "GINASAURUS TripsController: #{@trip.id} ID CREATED"
      render json: @trip, status: :created, location: @trip
    else
      # puts "GINASAURUS TripsController: TRIP NOT CREATED"
      render json: @trip.errors, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  # DELETE /trips/:id
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    render json: { message: "Trip deleted successfully." }
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Trip not found." }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /trips
  def index
    @all_trips = Trip.all
    render json: @all_trips
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def invalid_trip_params?(params)
    params.values.any?(&:blank?)
  end

  def trip_params
    trip_params = params.require(:trip).permit(:chauffeur_id, :ride_id)
    puts "GINASAURUS DEBUG: TripsController: trip_params: #{trip_params}."
    trip_params
  end

end
