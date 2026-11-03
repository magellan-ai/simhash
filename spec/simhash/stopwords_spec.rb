# frozen_string_literal: true

RSpec.describe Simhash::Stopwords do
  %i[EN RU ALL WORDS].each do |list_name|
    it "freezes #{list_name}" do
      expect(described_class.const_get(list_name)).to be_frozen
    end
  end

  describe 'EN' do
    it 'lists every English stopword' do
      expect(described_class::EN.split.size).to eq(671)
    end

    it 'keeps words that YAML would read as booleans or fail to parse' do
      expect(described_class::EN.split).to include('yes', 'no', 'on', 'off', "'ll", "'ve")
    end
  end

  describe 'RU' do
    it 'lists every Russian stopword' do
      expect(described_class::RU.split.size).to eq(421)
    end
  end

  describe 'ALL' do
    it 'combines the Russian and English stopwords' do
      expect(described_class::ALL).to eq(described_class::RU + described_class::EN)
    end
  end

  describe 'WORDS' do
    it 'holds exactly the words in ALL' do
      expect(described_class::WORDS).to eq(Set.new(described_class::ALL.split))
    end
  end
end
