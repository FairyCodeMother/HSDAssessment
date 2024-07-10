# app/controllers/rides_controller.rb
class RidesController < ApplicationController

    def index
        service = GoogleDirectionsService.new
      
        hours = service.get_duration_hours(start_address, destination_address)
        miles = service.get_distance_miles(home_address, start_address, destination_address)
      
        render json: { times: hours, distances: miles }
    end
  
    # Returns in dollars- Higher is better
    def calculate_score_and_render(earnings, c_duration, r_duration)
        # ride_earnings = earnings
        # commute_duration = c_duration
        # ride_duration = r_duration
        ride_earnings = 50.0
        commute_duration = 30
        ride_duration = 45
    
        score = RideScoringService.calculate_score(ride_earnings, commute_duration, ride_duration)
        render json: { score: score }
    end

    # Returns a paginated JSON list of rides in descending score order for a given driver
    # Calculate the score of a Trip (ride in $ per hour as: (ride earnings) / (commute duration + ride duration))
    # GET /rides/get_trips_by_driver
    def get_trips_by_driver
        # This gets the driver_id from the URL
        driver_id = params[:id]

        # Execute SQL query to fetch driver_id from drivers table
        result = ActiveRecord::Base.connection.execute("SELECT driver_id FROM drivers LIMIT 1")
    
        # Extract driver_id from the result (assuming it returns one row)
        if result.any?
            result_id = result.first['driver_id']
            render json: { 
                driver_id: driver_id,
                message: "you made it! your num: #{driver_id} and our num: #{result_id}!"

             }
        else
            render json: { error: "No driver found" }, status: :not_found
        end
    
    rescue ActiveRecord::StatementInvalid => e
        render json: { error: e.message }, status: :internal_server_error
        
        # Fetch the trips for the given driver_id. Assuming you have a Ride model.
        # @trips = Ride.where(driver_id: driver_id)

        # Sort the Rides desc: Higher is better!
    
        # Render the trips as JSON or handle according to your application needs
        # render json: @trips
      end

end
