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
    def get_trips_by_driver
        driver_id = params[:id]
    
        render json: {
            driver_id: driver_id,
            message: "you made it"
        }
        
        # Fetch the trips for the given driver_id. Assuming you have a Ride model.
        # @trips = Ride.where(driver_id: driver_id)

        # Sort the Rides desc: Higher is better!
    
        # Render the trips as JSON or handle according to your application needs
        # render json: @trips
      end

end
  