require 'rails_helper'

describe FalseClass do

  describe '#to_i' do
    it 'returns 0' do
      expect(false.to_i).to eq(0)
    end
  end

  describe '#to_bool' do
    it 'returns false' do
      expect(false.to_bool).to eq(false)
    end
  end

end
