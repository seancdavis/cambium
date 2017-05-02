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

  describe '#possessive' do
    it 'adds an apostrophe when ending in s' do
      expect('Davis'.possessive).to eq("Davis'")
    end
    it 'adds an apostrophe-S when not ending in s' do
      expect('Sean'.possessive).to eq("Sean's")
    end
  end

  describe '#paragraphs' do
    it 'breaks on newlines' do
      txt = "I\nAnd Love\nAnd You"
      expect(txt.paragraphs).to eq(['I', 'And Love', 'And You'])
    end
    it 'removes extra newlines' do
      txt = "I\n\nAnd Love\n\nAnd You"
      expect(txt.paragraphs).to eq(['I', 'And Love', 'And You'])
    end
  end

  describe '#sentences' do
    it 'breaks on periods, exclamation marks, and question marks' do
      txt = "I? And, Love. And You! And Us"
      expect(txt.sentences).to eq(['I?', 'And, Love.', 'And You!', 'And Us'])
    end
  end

end
