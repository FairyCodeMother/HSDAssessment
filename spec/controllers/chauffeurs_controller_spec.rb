# spec/controllers/chauffeurs_controller_spec.rb
require 'rails_helper'

RSpec.describe ChauffeursController, type: :controller do
  describe 'GET #index' do
    let!(:chauffeurs) { create_list(:chauffeur, 3) }

    describe '#get_all_chauffeur_rides' do
      let(:chauffeur) { create(:chauffeur) }
      let(:rides) { create_list(:ride, 3) }

      it 'returns all rides' do
        expect(chauffeur.get_all_chauffeur_rides).to match_array(rides)
      end
    end
  end

    # it 'returns a successful response' do
    #   puts "Logging: Starting GET #index test"
    #   get :index
    #   expect(response).to be_successful
    #   puts "Logging: GET #index test completed successfully"
    # end
  # end
end
