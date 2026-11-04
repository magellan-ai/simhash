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

      it 'drops stopwords containing punctuation when punctuation is preserved' do
        expect(described_class.filtered_tokens(["Don't panic"], stop_words: true, preserve_punctuation: true))
          .to eq(['panic'])
      end
    end

    it 'rejects unknown options' do
      expect { described_class.hash(%w[word], hashbit: 64) }.to raise_error(ArgumentError, /hashbit/)
    end

    it 'rejects an unknown hashing_method even when there are no tokens to hash' do
      expect { described_class.hash([], hashing_method: :no_such_hash) }.to raise_error(ArgumentError, /no_such_hash/)
    end
  end

  describe '.each_filtered_token' do
    it 'rejects unknown options' do
      expect { described_class.each_filtered_token(%w[word], stopwords: true) { |token| token } }
        .to raise_error(ArgumentError, /stopwords/)
    end
  end

  describe '.filtered_tokens' do
    it 'drops tokens shorter than token_min_size' do
      expect(described_class.filtered_tokens(%w[a bb ccc], token_min_size: 2)).to eq(%w[bb ccc])
    end

    it 'rejects unknown options' do
      expect { described_class.filtered_tokens(%w[word], min_size: 2) }.to raise_error(ArgumentError, /min_size/)
    end

    it 'rejects a non-Integer token_min_size even when there are no tokens' do
      expect { described_class.filtered_tokens([], token_min_size: nil) }.to raise_error(TypeError, /token_min_size/)
    end

    it 'rejects a non-Integer token_min_size even when filtering empties every token' do
      expect { described_class.filtered_tokens(['the'], stop_words: true, token_min_size: '2') }
        .to raise_error(TypeError, /token_min_size/)
    end

    it 'measures token_min_size in characters, not bytes' do
      expect(described_class.filtered_tokens(%w[я мы], token_min_size: 2)).to eq(%w[мы])
    end

    it "measures token_min_size in the token's own encoding" do
      shift_jis_token = '日本'.encode('Shift_JIS')

      expect(described_class.filtered_tokens([shift_jis_token], preserve_punctuation: true, token_min_size: 3)).to be_empty
    end

    it 'filters without emitting warnings' do
      expect { described_class.filtered_tokens(['Слово']) }.not_to output.to_stderr
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

    it 'drops tokens that match a stop sentence' do
      expect(described_class.filtered_tokens(['Hello there', 'keep me'], stop_sentences: ' hello there '))
        .to eq(['keep me'])
    end

    context 'with the deprecated stop_sentenses: spelling' do
      it 'still drops tokens that match a stop sentence' do
        expect(described_class.filtered_tokens(['Hello there', 'keep me'], stop_sentenses: ' hello there '))
          .to eq(['keep me'])
      end

      it 'rejects being combined with stop_sentences:' do
        expect { described_class.filtered_tokens(['keep me'], stop_sentences: ' a ', stop_sentenses: ' b ') }
          .to raise_error(ArgumentError, /not both/)
      end

      it 'stays silent unless deprecation warnings are enabled' do
        expect { described_class.filtered_tokens(['keep me'], stop_sentenses: ' hello there ') }.not_to output.to_stderr
      end

      context 'with deprecation warnings enabled', deprecation_warnings: true do
        it "warns at the caller's line" do
          expect { described_class.filtered_tokens(['keep me'], stop_sentenses: ' hello there ') }
            .to output(/\A#{Regexp.escape(__FILE__)}:\d+: warning: .*stop_sentenses: is deprecated/).to_stderr
        end

        it "warns at the caller's line when called through String#simhash" do
          expect { 'keep me'.simhash(stop_sentenses: ' hello there ') }
            .to output(/\A#{Regexp.escape(__FILE__)}:\d+: warning: .*stop_sentenses: is deprecated/).to_stderr
        end
      end
    end
  end
end
