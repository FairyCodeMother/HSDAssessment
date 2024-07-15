# spec/controllers/chauffeurs_controller_spec.rb
require 'rails_helper'

RSpec.describe ChauffeursController, type: :controller do
    fixtures_paths = [Rails.root.join("spec", "fixtures")]
    describe 'GET #index' do
    let!(:chauffeurs) { create_list(:chauffeur, 3) }

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all chauffeurs' do
      get :index
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET #show' do
    let(:chauffeur) { create(:chauffeur) }

    it 'returns a successful response' do
      get :show, params: { id: chauffeur.id }
      expect(response).to be_successful
    end

    it 'returns the correct chauffeur' do
      get :show, params: { id: chauffeur.id }
      expect(JSON.parse(response.body)['id']).to eq(chauffeur.id)
    end
  end
end
