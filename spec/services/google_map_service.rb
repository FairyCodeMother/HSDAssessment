# spec/services/google_map_service_spec.rb
require 'rails_helper'
require 'google-maps'

RSpec.describe GoogleMapService do
  describe '#get_route_info' do
    let(:service) { GoogleMapService.new }
    let(:origin) { 'Origin Address' }
    let(:destination) { 'Destination Address' }

    context 'when data is not cached' do
      before do
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(service).to receive(:get_route_miles).and_return(10.0)
        allow(service).to receive(:get_route_minutes).and_return(20.0)
      end

      it 'fetches and caches route info' do
        expect(Rails.cache).to receive(:write).with(any_args).once
        result = service.get_route_info(origin, destination)
        expect(result[:miles]).to eq(10.0)
        expect(result[:minutes]).to eq(20.0)
      end
    end

    context 'when data is cached' do
      before do
        allow(Rails.cache).to receive(:read).and_return({ miles: 5.0, minutes: 15.0 })
      end

      it 'returns cached route info' do
        expect(service).not_to receive(:get_route_miles)
        expect(service).not_to receive(:get_route_minutes)
        result = service.get_route_info(origin, destination)
        expect(result[:miles]).to eq(5.0)
        expect(result[:minutes]).to eq(15.0)
      end
    end

    context 'when an error occurs' do
      before do
        allow(service).to receive(:get_route_miles).and_raise(StandardError, 'API error')
      end

      it 'returns an error message' do
        result = service.get_route_info(origin, destination)
        expect(result[:error]).to match(/API error/)
      end
    end
  end

  describe '#get_batch_route_info' do
    let(:service) { GoogleMapService.new }

    context 'with multiple queries' do
      let(:queries) { [{ origin: 'Origin1', destination: 'Dest1' }, { origin: 'Origin2', destination: 'Dest2' }] }

      before do
        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(Google::Maps).to receive(:batch_request).and_return([
          { distance: 10.0, duration: 20.0 },
          { distance: 15.0, duration: 25.0 }
        ])
      end

      it 'fetches and caches batch route info' do
        expect(Rails.cache).to receive(:write).twice
        results = service.get_batch_route_info(queries)
        expect(results.size).to eq(2)
        expect(results['route_info/Origin1/Dest1']).to eq({ miles: 10.0, minutes: 20.0 })
        expect(results['route_info/Origin2/Dest2']).to eq({ miles: 15.0, minutes: 25.0 })
      end
    end

    context 'when all queries are cached' do
      let(:queries) { [{ origin: 'Origin1', destination: 'Dest1' }] }

      before do
        allow(Rails.cache).to receive(:read).and_return({ miles: 10.0, minutes: 20.0 })
      end

      it 'returns cached route info for all queries' do
        expect(Google::Maps).not_to receive(:batch_request)
        results = service.get_batch_route_info(queries)
        expect(results.size).to eq(1)
        expect(results['route_info/Origin1/Dest1']).to eq({ miles: 10.0, minutes: 20.0 })
      end
    end

    context 'when an error occurs' do
      let(:queries) { [{ origin: 'Origin1', destination: 'Dest1' }] }

      before do
        allow(Google::Maps).to receive(:batch_request).and_raise(StandardError, 'API error')
      end

      it 'returns an error message' do
        results = service.get_batch_route_info(queries)
        expect(results['route_info/Origin1/Dest1'][:error]).to match(/API error/)
      end
    end
  end
end
