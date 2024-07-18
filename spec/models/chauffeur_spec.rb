# spec/models/chauffeur_spec.rb
require 'rails_helper'

RSpec.describe Chauffeur, type: :model do
  describe 'factories' do
    it 'creates chauffeurs from the array' do
      create(:chauffeur, :from_array)
      expect(Chauffeur.count).to eq(5) # 1 initial + 4 array
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:home_address) }
  end

  describe 'callbacks' do
    it 'sets chauffeur id before creation if blank' do
      chauffeur = build(:chauffeur, id: nil)
      expect { chauffeur.save }.to change { chauffeur.id }.from(nil).to(be_a(String).and start_with('c'))
    end
  end

  describe 'custom methods' do
    let(:chauffeur) { create(:chauffeur) }

    describe '#get_all_chauffeur_rides' do
      it 'returns all rides' do
        # Create rides for testing
        create_list(:ride, 3)
        expect(chauffeur.get_all_chauffeur_rides.count).to eq(3)
      end

      it 'raises an error if rides are not found' do
        expect { chauffeur.get_all_chauffeur_rides }.not_to raise_error
      end
    end
  end

end
