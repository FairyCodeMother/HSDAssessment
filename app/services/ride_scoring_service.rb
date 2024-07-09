# app/services/ride_scoring_service.rb
class RideScoringService

    # Higher $ is better
    def self.calculate_score(ride_earnings, commute_duration, ride_duration)
        
        # TODO: Replace with Trip total_duration
        total_duration = commute_duration + ride_duration
      
        score = ride_earnings.to_f / total_duration.to_f # Calculate score$ per hour
      
        score.round(2) # in dollars
    end
end
  