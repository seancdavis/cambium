require 'rails_helper'

describe Array do

  describe '#average' do
    it 'returns nil when there are no items' do
      expect([].average).to eq(nil)
    end
    it 'returns the average' do
      expect([1, 2, 3].average).to eq(2.0)
    end
  end

end
