# app/controllers/trips_controller.rb
class TripsController < ApplicationController

  # GET /trips
  def index
    @all_trips = Trip.all
    render json: @all_trips
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create
    chauffeur_id = params[:chauffeur_id]
    ride_id = params[:ride_id]

    @trip = Trip.create_trip_by_ids(chauffeur_id, ride_id)if @trip.save

    if @trip.save
      render json: @trip, status: :created, location: @trip
    else
      render json: @trip.errors, status: :unprocessable_entity
    end

    # render json: { message: "Trip created successfully." }, status: :created
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
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

  private

  def trip_params
    params.require(:trip).permit(:chauffeur_id, :ride_id)
  end

end
