# spec/controllers/trips_controller_spec.rb
require 'rails_helper'

RSpec.describe TripsController, type: :controller do
  let(:chauffeur) { create(:chauffeur, :home_address) }
  let(:ride) { create(:ride, pickup_address: '4700 West Guadalupe, Austin, TX', dropoff_address: '3600 Presidential Blvd, Austin, TX') }
  let!(:trip) { create(:trip, chauffeur: chauffeur, ride: ride) }

  describe "POST #create" do
    it "does not create a Trip with invalid params" do
      expect {
        post :create, params: { trip: { chauffeur_id: chauffeur.id, ride_id: nil } }
      }.not_to change(Trip, :count)

      expect(response).to have_http_status(:bad_request)
    end

    it "creates a new Trip with valid params" do
      # Stub CalculatorService methods to return real values
      allow_any_instance_of(CalculatorService).to receive(:calculate_route_metrics).and_return({ miles: 10.0, minutes: 20.0 })
      allow_any_instance_of(CalculatorService).to receive(:calculate_earnings).and_return(100.0)

      expect {
        post :create, params: { trip: { chauffeur_id: chauffeur.id, ride_id: ride.id } }
      }.to change(Trip, :count).by(1)

      # Ensure the response status is correct (Status Code 201: Created)
      expect(response).to have_http_status(:created)
    end
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "returns all trips" do
      create_list(:trip, 3, chauffeur: chauffeur, ride: ride)
      get :index
      expect(json_response.size).to eq(Trip.count)
    end
  end

  describe "DELETE #destroy" do
    context "with a valid id" do
      it "deletes the trip" do
        expect {
          delete :destroy, params: { id: trip.id }
        }.to change(Trip, :count).by(-1)
      end

      it "returns a success response" do
        delete :destroy, params: { id: trip.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with an invalid id" do
      it "returns a not found response" do
        delete :destroy, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq("Trip not found.")
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end


end
