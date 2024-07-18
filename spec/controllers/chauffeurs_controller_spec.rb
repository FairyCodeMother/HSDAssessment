# spec/controllers/chauffeurs_controller_spec.rb
require 'rails_helper'

RSpec.describe ChauffeursController, type: :controller do

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Chauffeur' do
        expect {
          post :create, params: { chauffeur: attributes_for(:chauffeur) }
        }.to change(Chauffeur, :count).by(1)
      end

      it 'renders a JSON response with the new chauffeur' do
        post :create, params: { chauffeur: attributes_for(:chauffeur) }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'GET #create_trips_by_chauffeur_id' do
    let!(:chauffeur) { create(:chauffeur, :home_address) }
    let!(:rides) { create_list(:ride, 3) }

    before do
      rides.each do |ride|
        create(:trip, chauffeur: chauffeur, ride: ride)
      end
    end

    context 'when chauffeur and rides exist' do
      it 'returns a paginated JSON list of trips in descending score order' do
        get :create_trips_by_chauffeur_id, params: { id: chauffeur.id, page: 1, per_page: 3 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(3) # Assumes per_page is 3

        # Ensure descending order by score
        scores = json_response.map { |trip| trip['score'].to_f } # Convert scores to float for accurate numeric sorting
        sorted_scores = scores.sort.reverse # Sort scores in descending order

        expect(scores).to eq(sorted_scores)
      end
    end

    context 'when there is an internal server error' do
      it 'returns an internal server error' do
        allow_any_instance_of(Chauffeur).to receive(:get_all_chauffeur_rides).and_raise(ActiveRecord::StatementInvalid)

        get :create_trips_by_chauffeur_id, params: { id: chauffeur.id, page: 1, per_page: 3 }

        expect(response).to have_http_status(:internal_server_error)
        expect(json_response['error']).to eq('An error occurred while processing your request')
      end
    end

  end

  describe 'DELETE #destroy' do
    let(:chauffeur) { create(:chauffeur) }

    it 'deletes the chauffeur' do
      chauffeur_id = chauffeur.id

      expect {
        delete :destroy, params: { id: chauffeur_id }
      }.to change(Chauffeur, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy, params: { id: chauffeur.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:chauffeur) { create(:chauffeur) }

    it 'returns a success response' do
      get :show, params: { id: chauffeur.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    let(:chauffeur) { create(:chauffeur) }

    context 'with valid params' do
      it 'updates the requested chauffeur' do
        patch :update, params: { id: chauffeur.to_param, chauffeur: { home_address: 'New Address' } }
        chauffeur.reload
        expect(chauffeur.home_address).to eq('New Address')
      end

      it 'renders a JSON response with the updated chauffeur' do
        patch :update, params: { id: chauffeur.to_param, chauffeur: { home_address: 'New Address' } }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the chauffeur' do
        patch :update, params: { id: chauffeur.to_param, chauffeur: { home_address: nil } }
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  def json_response
    JSON.parse(response.body)
  end

end
