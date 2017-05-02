require 'rails_helper'

describe Fixnum do

  describe '#nearest_half' do
    it 'returns a float of itself' do
      expect(1.nearest_half).to eq(1.0)
    end
  end

  describe '#to_bool' do
    it 'returns true for 1' do
      expect(1.to_bool).to eq(true)
    end
    it 'returns false for 0' do
      expect(0.to_bool).to eq(false)
    end
    it 'raises an error for all other numbers' do
      expect { 2.to_bool }.to raise_error(ArgumentError)
    end
  end

end
