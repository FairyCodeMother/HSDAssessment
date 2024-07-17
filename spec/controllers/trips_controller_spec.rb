# spec/controllers/trips_controller_spec.rb
require 'rails_helper'

RSpec.describe TripsController, type: :controller do

  let(:chauffeur) { create(:chauffeur, home_address: '1201 S Lamar Blvd, Austin, TX') }
  let(:ride) { create(:ride, pickup_address: '4700 West Guadalupe, Austin, TX', dropoff_address: '3600 Presidential Blvd, Austin, TX') }
  # let(:trip) { create(:trip, chauffeur_id: chauffeur.id, ride_id: ride.id)}




  describe "POST #create" do
    # ==== GOOD ============================================================
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

      # puts "GINASAURUS TripsControllerSpec DEBUG: Trip count before create: #{Trip.count}"
      # should be: 0

      puts "GINASAURUS TripsControllerSpec DEBUG: #{chauffeur.id}c ID, #{ride.id} rID"
      # GINASAURUS DEBUG: Chauffeur ID: c54e17e09-7026-4868-ad21-fa9b1c016e9e, Ride ID: rd53bcb54-cdc2-4c1e-8c4e-d3dfecbb77ee

      expect {
        post :create, params: { trip: { chauffeur_id: chauffeur.id, ride_id: ride.id } }
      }.to change(Trip, :count).by(1)

      # Debugging: Check response and any error messages (Status Code 201: Created)
      # if response.status != 201
      #   puts "GINASAURUS DEBUG TripControllerSpec: Response status: #{response.status}"
      #   puts "GINASAURUS DEBUG TripControllerSpec: Response body: #{response.body}"
      # end

      # Ensure the response status is correct (Status Code 201: Created)
      expect(response).to have_http_status(:created)
    end
    # ==== GOOD ============================================================






    it "creates a new Trip with valid params" do
      allow_any_instance_of(CalculatorService).to receive(:calculate_route_metrics).and_return({ miles: 10.0, minutes: 20.0 })
      allow_any_instance_of(CalculatorService).to receive(:calculate_earnings).and_return(100.0)

      puts "GINASAURUS DEBUG: Trip count before create: #{Trip.count}"
      puts "GINASAURUS DEBUG: #{chauffeur.id} cID, Ride ID: #{ride.id} rID"
      # Returns: GINASAURUS DEBUG: Chauffeur ID: c280c4017-5609-4f8a-95ac-9b1e0b3a3e5a, Ride ID: r9fcbe780-df74-4620-8a9f-a3709b2a5b2f

      expect {
        puts "GINASAURUS DEBUG inside EXPECT: #{chauffeur.id} cID, Ride ID: #{ride.id} rID"
        # Returns: GINASAURUS DEBUG inside EXPECT: c76e126e8-4b5e-40a0-8e2b-a653580a6657 cID, Ride ID: rc19a1bd8-fcde-4524-9db2-ed5ab096f2b4 rID
        post :create, params: { trip: { chauffeur_id: chauffeur.id, ride_id: ride.id } }
      }.to change(Trip, :count).by(1)

      puts "GINASAURUS TRIPS CON: #{Trip.count} ct- CREATE: c ID: #{chauffeur.id}, r ID: #{ride.id}"

      # Debugging: Check response and any error messages
      if response.status != 200
        puts "GINASAURUS TRIPS CON DEBUG: Response status: #{response.status}"
        puts "GINASAURUS TRIPS CON DEBUG: Response body: #{response.body}"
      end

      # Ensure the response status is correct (HTTP Status 201: Created)
      expect(response).to have_http_status(:created)
    end
    # END: it "creates a new Trip with valid params" do



  end

  def json_response
    JSON.parse(response.body)
  end



      # # Stub CalculatorService methods to return real values
      # allow_any_instance_of(CalculatorService).to receive(:calculate_route_metrics).and_wrap_original do |method, *args|
      #   result = method.call(*args)
      #   result || { miles: 0.0, minutes: 0.0 }
      # end

      # allow_any_instance_of(CalculatorService).to receive(:calculate_earnings).and_wrap_original do |method, *args|
      #   result = method.call(*args)
      #   result || 0.0
      # end
      # puts "GINASAURUS TRIPS CON: #{Trip.count} ct- CREATE: c ID: #{chauffeur.id}, r ID: #{ride.id}"
      # Returns > GINASAURUS TRIPS CON: 0 ct- CREATE: c ID: ce702848d-88ed-47c0-a61f-aa32a93c9596, r ID: rb43cc5eb-5c89-4c7c-9273-c1c9909ae60d

      # expect {
      #   post :create, params: { trip: { chauffeur_id: chauffeur.id, ride_id: ride.id } }
      # }.to change(Trip, :count).by(1)
      # end

      # it "returns a created response with valid parameters" do
      #   post :create, params: { trip: { chauffeur_id: chauffeur.id, ride_id: ride.id } }
      #   expect(response).to have_http_status(:created)
      # end





end




# describe "GET #index" do
#   it "returns a success response" do
#     get :index
#     puts "GINASAURUS: Response body: #{response.body}"
#     expect(response).to be_successful
#     expect(json_response).not_to be_empty
#   end

#   it "returns all trips" do
#     get :index
#     puts "GINASAURUS: All trips: #{Trip.all.inspect}"
#     expect(json_response.size).to eq(Trip.count)
#   end
# end


# describe "DELETE #destroy" do
#   context "with a valid id" do
#     it "deletes the trip" do
#       expect {
#         delete :destroy, params: { id: trip.id }
#       }.to change(Trip, :count).by(-1)
#     end

#     it "returns a success response" do
#       delete :destroy, params: { id: trip.id }
#       expect(response).to be_successful
#       expect(json_response['message']).to eq("Trip deleted successfully.")
#     end
#   end

#   context "with an invalid id" do
#     it "returns a not found response" do
#       delete :destroy, params: { id: 999 }
#       expect(response).to have_http_status(:not_found)
#       expect(json_response['error']).to eq("Trip not found.")
#     end
#   end
# end
