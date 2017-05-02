require 'rails_helper'

describe Hash, :focus => true do

  describe '#to_ostruct' do
    it 'returns an OpenStruct object' do
      expect({}.to_ostruct).to eq(OpenStruct.new)
    end
    it 'returns a recursive OpenStruct' do
      hash = { :a => '1', :b => 2, :c => [3, 4, 5], :d => { :e => '6' } }
      ostruct = OpenStruct.new(
        :a => '1',
        :b => 2,
        :c => [3, 4, 5],
        :d => OpenStruct.new(:e => '6')
      )
      expect(hash.to_ostruct).to eq(ostruct)
    end
  end

end
