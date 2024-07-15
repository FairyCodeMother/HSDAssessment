# app/models/chauffeur.rb

# A Chauffeur consists of a name and home_address
class Chauffeur < ApplicationRecord
  has_many :trips

  validates :home_address, presence: true

  self.primary_key = 'id'

  # Get all Rides for this Chauffeur
  def get_all_chauffeur_rides
    # Example filtering logic (adjust as per your actual business rules)
    # Fetching all Rides (from seeds) for now
    Ride.all
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Rides not found' }, status: :not_found
  end

  # Set Chauffeur ID before creation if blank
  before_create :set_chauffeur_id

  private

  # Custom key starts with "u"
  def set_chauffeur_id
    self.id = "u#{SecureRandom.uuid}" if id.blank?
  end
end
