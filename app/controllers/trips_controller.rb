# app/controllers/trips_controller.rb
class TripsController < ApplicationController

  # POST /trip
  def create
    if invalid_trip_params?(trip_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    chauffeur = Chauffeur.find_by(id: trip_params[:chauffeur_id])
    ride = Ride.find_by(id: trip_params[:ride_id])
    if chauffeur.nil? || ride.nil?
      render json: { error: 'Chauffeur or Ride not found' }, status: :not_found
      return
    end

    begin
      @trip = Trip.create_trip_by_ids(chauffeur.id, ride.id)
      if @trip.save
        render json: @trip, status: :created, location: @trip
      else
        render json: @trip.errors, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  # DELETE /trips/:id
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    render json: { message: 'Trip deleted successfully.' }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Trip not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /trips
  # Would normally add pagination
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
    params.require(:trip).permit(:chauffeur_id, :ride_id)
  end

end
