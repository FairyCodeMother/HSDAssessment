# spec/services/calculator_service_spec.rb
require 'rails_helper'

RSpec.describe CalculatorService do
  let(:service) { CalculatorService.new }

  describe '#calculate_earnings' do
    it 'calculates earnings correctly' do
      # 12 + (1.5 * (17-5)) + (.7 * (36-15)) = 44.7
      expect(service.calculate_earnings(17, 36)).to eq(44.7)
    end
  end

  describe '#calculate_totals' do
    it 'calculates totals correctly' do
      commute = { miles: 5, minutes: 20 }
      ride_values = { miles: 10, minutes: 30 }

      totals = service.calculate_totals(commute, ride_values)

      expect(totals[:total_miles]).to eq(15)
      expect(totals[:total_minutes]).to eq(50)
      expect(totals[:total_hours].round(2)).to eq(0.83) # 50 minutes / 60
    end
  end

  describe '#calculate_route_metrics' do
    it 'calculates route metrics correctly' do
      starting_address = '123 Main St, Anytown, USA'
      ending_address = '456 Oak Ave, Othertown, USA'

      # Stub GoogleMapService for testing
      allow_any_instance_of(GoogleMapService).to receive(:get_route_info)
        .and_return({ miles: 15, minutes: 45 })

      route_metrics = service.calculate_route_metrics(starting_address, ending_address)

      expect(route_metrics[:miles]).to eq(15)
      expect(route_metrics[:minutes]).to eq(45)
    end
  end

  describe '#calculate_score' do
    it 'calculates score correctly' do
      earnings = 30.0
      total_miles = 15.0

      score = service.calculate_score(earnings, total_miles)

      expect(score).to eq(2.0) # 30 / 15
    end
  end
end
