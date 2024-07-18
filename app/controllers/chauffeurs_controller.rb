# /app/controllers/chauffeurs_controller.rb
class ChauffeursController < ApplicationController
  before_action :set_chauffeur, only: [:show, :update, :destroy]

  # POST /chauffeurs
  def create
    @chauffeur = Chauffeur.new(chauffeur_params)

    if invalid_chauffeur_params?(chauffeur_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    if @chauffeur.save
      render json: @chauffeur, status: :created, location: @chauffeur
    else
      render json: @chauffeur.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /chauffeurs/:id/trips
  # Returns a paginated JSON list of rides in descending score order for a given Chauffeur
  def create_trips_by_chauffeur_id
    # puts "GINASAURUS ChauffeursController DEBUG: params: #{params}."
    # puts "GINASAURUS ChauffeursController DEBUG: #{params[:id]} cID."

    # Use a random Chauffeur for development
    @chauffeur = Chauffeur.order('RANDOM()').first  # Chauffeur.find(params[:id])
    unless @chauffeur
      render json: { error: 'Chauffeur not found' }, status: :not_found
      return
    end

    chauffeur_rides = @chauffeur.get_all_chauffeur_rides

    # Create a list of Trips: Trip = Chauffeur + Ride
    trip_list = chauffeur_rides.map do |ride|
      Trip.create_trip_by_ids(@chauffeur.id, ride.id)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unprocessable_entity
      return
    end

    # Sort the Trips desc: Higher is better!
    sorted_trips = trip_list.sort_by(&:score).reverse

    # Pagination
    page = params[:page].to_i.positive? ? params[:page].to_i : 1
    per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
    offset = (page - 1) * per_page
    paginated_trips = sorted_trips.slice(offset, per_page)

    render json: paginated_trips, status: :ok

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Chauffeur not found' }, status: :not_found
  rescue ActiveRecord::StatementInvalid => e
    render json: { error: 'An error occurred while processing your request' }, status: :internal_server_error
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # DELETE /chauffeurs/:id
  def destroy
    if @chauffeur.destroy
      head :no_content
    else
      render json: { error: 'Unable to delete chauffeur' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /chauffeurs
  # Would normally add pagination
  def index
    @all_chauffeurs = Chauffeur.all
    render json: @all_chauffeurs
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /chauffeurs/:id
  def show
    render json: @chauffeur
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # PATCH/PUT /chauffeurs/:id
  def update
    if invalid_chauffeur_params?(chauffeur_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    if @chauffeur.update(chauffeur_params)
      render json: @chauffeur, status: :ok
    else
      render json: @chauffeur.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def chauffeur_params
    params.require(:chauffeur).permit(:home_address)
  end

  def invalid_chauffeur_params?(params)
    params.values.any?(&:blank?)
  end

  def set_chauffeur
    @chauffeur = Chauffeur.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Chauffeur not found' }, status: :not_found
  end

end
