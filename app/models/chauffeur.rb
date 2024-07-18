# app/models/chauffeur.rb

# A Chauffeur consists of a name and home_address
class Chauffeur < ApplicationRecord
  has_many :trips
  validates :home_address, presence: true

  self.primary_key = 'id'

  # Set Chauffeur ID before creation if blank
  before_create :set_chauffeur_id

  # Get all Rides for this Chauffeur
  def get_all_chauffeur_rides
    Ride.all  # Fetching all Rides (from seeds) for now

  rescue ActiveRecord::RecordNotFound => e
    # Handle the case where no rides are found
    Rails.logger.error "Rides not found: #{e.message}"
    []
  end

  private

  # Custom key starts with "c"
  def set_chauffeur_id
    self.id = "c#{SecureRandom.uuid}" if id.blank?
  end
end
