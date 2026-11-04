# frozen_string_literal: true

require 'rbconfig'

RSpec.describe Simhash::Stopwords do
  describe 'WORDS' do
    it 'is frozen' do
      expect(described_class::WORDS).to be_frozen
    end

    it 'holds every English and Russian stopword' do
      expect(described_class::WORDS.size).to eq(1092)
    end

    it 'keeps words that YAML would read as booleans or fail to parse' do
      expect(described_class::WORDS).to include('yes', 'no', 'on', 'off', "'ll", "'ve")
    end

    it 'holds exactly the words in ALL' do
      expect(described_class::WORDS).to eq(Set.new(described_class::ALL.split))
    end
  end

  describe 'the deprecated space-delimited strings' do
    %i[EN RU ALL].each do |list_name|
      it "freezes #{list_name}" do
        expect(described_class.const_get(list_name)).to be_frozen
      end
    end

    it 'lists every English stopword in EN' do
      expect(described_class::EN.split.size).to eq(671)
    end

    it 'lists every Russian stopword in RU' do
      expect(described_class::RU.split.size).to eq(421)
    end

    it 'combines the Russian and English stopwords in ALL' do
      expect(described_class::ALL).to eq(described_class::RU + described_class::EN)
    end

    context 'with deprecation warnings enabled', deprecation_warnings: true do
      %i[EN RU ALL].each do |list_name|
        it "warns when #{list_name} is referenced" do
          expect { described_class.const_get(list_name) }
            .to output(/constant Simhash::Stopwords::#{list_name} is deprecated/).to_stderr
        end
      end

      it 'is never referenced by the gem itself' do
        script = 'require "simhash"; Simhash.filtered_tokens(["the word"], stop_words: true)'
        command = [RbConfig.ruby, '-W:deprecated', '-I', File.expand_path('../../lib', __dir__), '-e', script]

        expect(IO.popen(command, err: %i[child out], &:read)).to be_empty
      end
    end
  end
end
