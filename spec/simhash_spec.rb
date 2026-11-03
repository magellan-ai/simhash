# frozen_string_literal: true

RSpec.describe Simhash do
  describe 'DEFAULT_STRING_HASH_METHOD' do
    it 'is the pure-Ruby hash' do
      expect(described_class::DEFAULT_STRING_HASH_METHOD).to eq(:hash_vl_rb)
    end
  end

  describe '.hash' do
    it 'fingerprints a whitespace-split sentence' do
      fingerprint = described_class.hash('In the beginning was the Word'.split, hashbits: 64, token_min_size: 2)

      expect(fingerprint.to_s).to eq('17095628911399577086')
    end

    it 'sets every bit when no token survives filtering' do
      fingerprint = described_class.hash('In the beginning was the Word'.split(/./), hashbits: 64, token_min_size: 2)

      expect(fingerprint.to_s).to eq('18446744073709551615')
    end

    it 'ignores case' do
      expect(described_class.hash('В Начале Было Слово'.split))
        .to eq(described_class.hash('в начале было Слово'.split))
    end

    context 'with stop_words enabled' do
      it 'matches the fingerprint of the ASCII content words alone' do
        expect(described_class.hash('In the beginning was the Word'.split, hashbits: 64, stop_words: true))
          .to eq(described_class.hash('Word'.split, hashbits: 64))
      end

      it 'matches the fingerprint of the non-ASCII content words alone' do
        expect(described_class.hash('В начале было Слово'.split, hashbits: 64, stop_words: true))
          .to eq(described_class.hash('начале Слово'.split, hashbits: 64))
      end
    end
  end

  describe '.filtered_tokens' do
    it 'drops tokens shorter than token_min_size' do
      expect(described_class.filtered_tokens(%w[a bb ccc], token_min_size: 2)).to eq(%w[bb ccc])
    end

    it 'strips punctuation and downcases' do
      expect(described_class.filtered_tokens(['Word,'])).to eq(['word'])
    end

    it 'separates on a non-breaking space, which \s does not match' do
      expect(described_class.filtered_tokens(["Word\u00A0Word"])).to eq(['word word'])
    end

    it 'keeps non-ASCII letters, which \W would strip' do
      expect(described_class.filtered_tokens(['Слово'])).to eq(['слово'])
    end
  end
end
