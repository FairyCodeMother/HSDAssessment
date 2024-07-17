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

  describe 'DELETE #destroy' do
    let(:chauffeur) { create(:chauffeur) }

    it 'deletes the chauffeur' do
      chauffeur_id = chauffeur.id
      # puts "<<<<<<<<<<< GINASAURUS: Spec DELETE chauffeur: #{chauffeur_id} (Chauffeur count BEFORE: #{Chauffeur.count})"

      expect {
        delete :destroy, params: { id: chauffeur_id }
        puts "GINASAURUS DEBUG DELETE: Chauffeur count AFTER: #{Chauffeur.count}. >>>>>>>>>>>>>"


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



end
