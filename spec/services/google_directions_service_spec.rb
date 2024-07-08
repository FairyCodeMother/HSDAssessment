# spec/services/google_directions_service_spec.rb
require 'rails_helper'

RSpec.describe GoogleDirectionsService, type: :service do
  let(:api_key) { 'test_api_key' }
  let(:service) { GoogleDirectionsService.new(api_key) }

  describe '#driving_distance' do
    it 'calculates the distance between two addresses' do
      # Mock the API response
      allow(service).to receive(:get_route).and_return({
        legs: [{ distance: { value: 10000 } }]
      })

      distance = service.driving_distance('start address', 'end address')
      expect(distance).to eq(6.21371) # 10000 meters in miles
    end
  end

  describe '#driving_duration' do
    it 'calculates the duration between two addresses' do
      # Mock the API response
      allow(service).to receive(:get_route).and_return({
        legs: [{ duration: { value: 3600 } }]
      })

      duration = service.driving_duration('start address', 'end address')
      expect(duration).to eq(1.0) # 3600 seconds in hours
    end
  end
end
