# spec/controllers/rides_controller_spec.rb
require 'rails_helper'

RSpec.describe RidesController, type: :controller do

  describe 'POST #create' do
    let(:valid_params) { { ride: { pickup_address: '2401 E 6th St, Austin, TX', dropoff_address: '11706 Argonne Forest Trail, Austin, TX' } } }

    it 'creates a new Ride with valid params' do
      # Stub methods of CalculatorService for predictable results
      allow_any_instance_of(CalculatorService).to receive(:calculate_route_metrics).and_return({ miles: 10.0, minutes: 20.0 })
      allow_any_instance_of(CalculatorService).to receive(:calculate_earnings).and_return(15.0)

      expect {
        post :create, params: valid_params
      }.to change(Ride, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include('pickup_address' => valid_params[:ride][:pickup_address])
      expect(JSON.parse(response.body)).to include('dropoff_address' => valid_params[:ride][:dropoff_address])
    end

    it 'returns unprocessable entity with invalid params' do
      # Stub CalculatorService methods to simulate invalid data scenarios
      allow_any_instance_of(CalculatorService).to receive(:calculate_route_metrics).and_return({ miles: 0.0, minutes: 0.0 })
      allow_any_instance_of(CalculatorService).to receive(:calculate_earnings).and_return(0.0)

      invalid_params = { ride: { pickup_address: nil, dropoff_address: '3600 Presidential Blvd, Austin, TX' } }

      expect {
        post :create, params: invalid_params
      }.not_to change(Ride, :count)

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GET #index' do
    it 'returns a JSON response with all rides' do
      create_list(:ride, 3)

      get :index

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(Ride.count)
    end
  end

  describe 'GET #show' do
    let(:ride) { create(:ride) }

    it 'returns not found if ride does not exist' do
      get :show, params: { id: 'invalid-id' }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to include('error' => 'Ride not found')
    end

    it 'returns a JSON response with the ride' do
      expect(ride.id).not_to be_nil

      get :show, params: { id: ride.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(ride.as_json)
    end
  end

  describe 'DELETE #destroy' do
    let(:ride) { create(:ride, pickup_address: '4700 West Guadalupe, Austin, TX', dropoff_address: '3600 Presidential Blvd, Austin, TX') }

    it 'deletes the ride' do
      ride_id = ride.id

      expect {
        delete :destroy, params: { id: ride_id }
      }.to change(Ride, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns not found if ride does not exist' do
      delete :destroy, params: { id: '123' }

      expect(response).to have_http_status(:not_found)
      body = JSON.parse(response.body)
      expect(body).to include('error' => 'Ride not found')
    end
  end

end
