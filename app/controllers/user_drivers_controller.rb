# app/controllers/user_drivers_controller.rb
class UserDriversController < ApplicationController
  before_action :set_user_driver, only: [:show, :update, :destroy]

  # GET /user_drivers
  def index
    @all_user_drivers = UserDriver.all
    render json: @all_user_drivers
  end

  # GET /user_drivers/:id
  def show
    render json: @user_driver
  end

  # POST /user_drivers
  def create
    @user_driver = UserDriver.new(user_driver_params)
    if @user_driver.save
      render json: @user_driver, status: :created, location: @user_driver
    else
      render json: @user_driver.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_drivers/:id
  def update
    if @user_driver.update(user_driver_params)
      render json: @user_driver
    else
      render json: @user_driver.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_drivers/:id
  def destroy
    @user_driver.destroy
    head :no_content
  end

  # Returns a paginated JSON list of rides in descending score order for a given user driver
  # Calculate the score of a Trip (ride in $ per hour as: (ride earnings) / (commute duration + ride duration))
  # GET /user_drivers/:id/trips
  def get_trips_by_user_driver_id
    # Placeholder for fetching a random UserDriver
    @user_driver = UserDriver.order('RANDOM()').first # UserDriver.find(params[:id])
    puts "[GINASAURUS] UserDriver ID: #{@user_driver.id}"

    user_driver_rides = @user_driver.get_all_user_driver_rides

    trip_list = []

    user_driver_rides.each do |ride|
      # Run Trip calculations
      calculator = CalculatorService.new(@user_driver, ride)
      commute_result = calculator.calculate_commute
      totals_result = calculator.calculate_totals(commute_result)
      earnings = calculator.calculate_earnings(totals_result)

      trip = Trip.create!(
        user_driver_id: @user_driver.id,
        ride_id: ride.id,
        commute_miles: commute_result[:commute_miles].to_f,
        commute_minutes: commute_result[:commute_minutes].to_f,
        total_miles: totals_result[:total_miles].to_f,
        total_minutes: totals_result[:total_minutes].to_f,
        total_hours: totals_result[:total_minutes].to_f / 60,
        earnings: earnings
      )
      trip_list << trip
    end

    # Sort the Rides desc: Higher is better!
    sorted_trips = trip_list.sort_by(&:earnings).reverse
    # render json: sorted_trips, status: :ok

    # Pagination
    page = params[:page].to_i || 1
    per_page = params[:per_page].to_i || 10
    offset = (page - 1) * per_page
    paginated_trips = sorted_trips[offset, per_page]

    render json: paginated_trips, status: :ok

  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User driver not found' }, status: :not_found
  rescue ActiveRecord::StatementInvalid => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_user_driver
    @user_driver = UserDriver.find(params[:id])
  end

  def user_driver_params
    params.require(:user_driver).permit(:name, :home_address)
  end
end
