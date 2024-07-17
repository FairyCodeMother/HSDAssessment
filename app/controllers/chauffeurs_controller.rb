# /app/controllers/chauffeurs_controller.rb
class ChauffeursController < ApplicationController
  # before_action :set_chauffeur, only: [:show, :update, :destroy]
  before_action :set_chauffeur, only: [:show, :update, :destroy]


  # GET /chauffeurs
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

  # POST /chauffeurs
  def create
    @chauffeur = Chauffeur.new(chauffeur_params)
    if @chauffeur.save
      render json: @chauffeur, status: :created, location: @chauffeur
    else
      render json: @chauffeur.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end


  # PATCH/PUT /chauffeurs/:id
  def update
    puts "GINASAURUS ChauffeursController DEBUG: chauffeur_params: #{chauffeur_params}."

    # Validate params
    if invalid_chauffeur_params?(chauffeur_params)
      render json: { error: 'Invalid parameters' }, status: :bad_request
      return
    end

    if @chauffeur.update(chauffeur_params)
      render json: @chauffeur
    else
      render json: @chauffeur.errors, status: :unprocessable_entity
    end
  end





  # Returns a paginated JSON list of rides in descending score order for a given Chauffeur
  # Calculate the score of a Trip (ride in $ per hour as: (ride earnings) / (commute duration + ride duration))
  # GET /chauffeurs/:id/trips
  def create_trips_by_chauffeur_id
    puts "GINASAURUS ChauffeursController DEBUG: params: #{params}."
    puts "GINASAURUS ChauffeursController DEBUG: #{params[:id]} cID."

    # Use a random Chauffeur for now
    @chauffeur = Chauffeur.order('RANDOM()').first
    chauffeur_rides = @chauffeur.get_all_chauffeur_rides

    # A Trip consists of a Chauffeur and a Ride
    trip_list = []
    chauffeur_rides.each do |ride|
      trip = Trip.create_trip_by_ids(@chauffeur.id, ride.id)
      puts "GINASAURUS ChauffeursController DEBUG: #{trip.id} t ID made with score #{trip.score}."

      trip_list << trip
    end

    # Sort the Rides desc: Higher is better!
    sorted_trips = trip_list.sort_by(&:score).reverse

    # Pagination
    page = params[:page].to_i.positive? ? params[:page].to_i : 1
    per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
    offset = (page - 1) * per_page
    paginated_trips = sorted_trips.slice(offset, per_page)

    render json: paginated_trips, status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Chauffeur not found' }, status: :not_found
  rescue ActiveRecord::StatementInvalid => e
    render json: { error: e.message }, status: :internal_server_error
  end




  # DELETE /chauffeurs/:id
  def destroy
    puts "GINASAURUS ChauffeursController DEBUG: Target Chauffeur: #{@chauffeur.id} cID."
    puts "=============================="

    @chauffeur.destroy
    puts "GINASAURUS ChauffeursController DEBUG: Destroy successful."
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: "Trip not found." }, status: :not_found
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
    # puts "GINASAURUS ChauffeursController DEBUG: Chauffeur set with ID: #{@chauffeur.id}"

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Chauffeur not found' }, status: :not_found
  end

end
