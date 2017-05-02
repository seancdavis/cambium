require 'rails_helper'

describe Float do

  describe '#nearest_half' do
    it 'rounds to the nearest half' do
      expect(0.24.nearest_half).to eq(0.0)
      expect(0.26.nearest_half).to eq(0.5)
      expect(0.74.nearest_half).to eq(0.5)
      expect(0.76.nearest_half).to eq(1.0)
    end
    it 'rounds up when equally between' do
      expect(0.25.nearest_half).to eq(0.5)
      expect(0.75.nearest_half).to eq(1.0)
    end
  end

end
