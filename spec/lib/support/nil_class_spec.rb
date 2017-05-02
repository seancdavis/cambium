require 'rails_helper'

describe NilClass do

  describe '#+' do
    it 'can be added to a string' do
      expect(nil + 'hello').to eq('hello')
    end
    it 'can be added to an integer' do
      expect(nil + 1).to eq(1)
    end
    it 'can be added to a float' do
      expect(nil + 1.5).to eq(1.5)
    end
  end

  describe '#to_bool' do
    it 'returns false' do
      expect(nil.to_bool).to eq(false)
    end
  end

end
