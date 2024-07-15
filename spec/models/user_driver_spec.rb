# spec/models/chauffeur_spec.rb
require 'rails_helper'

RSpec.describe Chauffeur, type: :model do
  fixtures_paths = [Rails.root.join("spec", "fixtures")]
  it { should validate_presence_of(:home_address) }

  describe '#get_all_chauffeur_rides' do
    let(:chauffeur) { create(:chauffeur) }
    let(:rides) { create_list(:ride, 3) }

    it 'returns all rides' do
      expect(chauffeur.get_all_chauffeur_rides).to match_array(rides)
    end
  end
end
