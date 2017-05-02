require 'rails_helper'

describe TrueClass do

  describe '#to_i' do
    it 'returns 1' do
      expect(true.to_i).to eq(1)
    end
  end

  describe '#to_bool' do
    it 'returns true' do
      expect(true.to_bool).to eq(true)
    end
  end

end
