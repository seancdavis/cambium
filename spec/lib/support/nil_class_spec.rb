require 'rails_helper'

describe NilClass do

  describe '#to_bool' do
    it 'returns false' do
      expect(nil.to_bool).to eq(false)
    end
  end

end
