# /app/controllers/chauffeurs_controller.rb
class ChauffeursController < ApplicationController
  before_action :set_chauffeur, only: [:show, :update, :destroy]

  # GET /chauffeurs
  def index
    @all_chauffeurs = Chauffeur.all
    render json: @all_chauffeurs
  end

  # GET /chauffeurs/:id
  def show
    render json: @chauffeur
  end

  # POST /chauffeurs
  def create
    @chauffeur = Chauffeur.new(chauffeur_params)
    if @chauffeur.save
      render json: @chauffeur, status: :created, location: @chauffeur
    else
      render json: @chauffeur.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chauffeurs/:id
  def update
    if @chauffeur.update(chauffeur_params)
      render json: @chauffeur
    else
      render json: @chauffeur.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chauffeurs/:id
  def destroy
    @chauffeur.destroy
    head :no_content
  end

  # Returns a paginated JSON list of rides in descending score order for a given Chauffeur
  # GET /chauffeurs/:id/trips
  def create_trips_by_chauffeur_id
    # Placeholder for fetching a random Chauffeur
    @chauffeur = Chauffeur.order('RANDOM()').first # Chauffeur.find(params[:id])
    chauffeur_id = @chauffeur.id

    chauffeur_rides = @chauffeur.get_all_chauffeur_rides
    chauffeur_home = @chauffeur.home_address

    trip_list = []

    # A Trip consists of a Chauffeur and a Ride
    chauffeur_rides.each do |ride|
      ride_id = ride.id
      puts "+++ [GINASAURUS] CHAUFFEUR: Using chauffeur_id: #{chauffeur_id}, ride id: #{ride_id} +++"

      trip = Trip.create_trip_by_ids(chauffeur_id, ride_id)
      trip_list << trip
    end

    # Sort the Rides desc: Higher is better!
    # Score = (ride in $ per hour as: (ride earnings) / (commute duration + ride duration))
    sorted_trips = trip_list.sort_by(&:score).reverse

    # Pagination
    page = params[:page].to_i.positive? ? params[:page].to_i : 1
    per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
    offset = (page - 1) * per_page
    paginated_trips = sorted_trips.slice(offset, per_page)
    # page = params[:page].to_i || 1
    # per_page = params[:per_page].to_i || 10
    # offset = (page - 1) * per_page
    # paginated_trips = sorted_trips[offset, per_page]

    render json: paginated_trips, status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Chauffeur not found' }, status: :not_found
  rescue ActiveRecord::StatementInvalid => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_chauffeur
    @chauffeur = Chauffeur.find(params[:id])
  end

  def chauffeur_params
    params.require(:chauffeur).permit(:home_address)
  end
end
