require 'rails_helper'

describe String do

  describe '#to_bool' do
    it 'returns true for truly strings' do
      %w{true t yes y 1}.each { |str| expect(str.to_bool).to eq(true) }
    end
    it 'returns false for falsey strings' do
      %w{false f no n 0}.each { |str| expect(str.to_bool).to eq(false) }
    end
    it 'raises an error for all other strings' do
      expect { 'balls'.to_bool }.to raise_error(ArgumentError)
    end
  end

end
