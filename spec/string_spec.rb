# frozen_string_literal: true

RSpec.describe String do
  describe '#simhash' do
    it 'fingerprints the receiver' do
      expect('In the beginning was the Word'.simhash(hashbits: 64).to_s).to eq('17095628911399577086')
    end

    it 'forwards its options to Simhash.hash' do
      expect('Я пошел'.simhash(stop_words: true)).to eq('пошел'.simhash(stop_words: true))
    end

    it 'tokenizes on the given separator' do
      expect('In the'.simhash(split_by: '')).to eq(Simhash.hash(['I', 'n', ' ', 't', 'h', 'e']))
    end

    it 'rejects unknown options' do
      expect { 'In the'.simhash(splitby: '') }.to raise_error(ArgumentError, /splitby/)
    end
  end

  describe '#hash_vl_rb' do
    it 'hashes to a stable value' do
      expect('Word'.hash_vl_rb(64)).to eq(10_958_914_953_375_318_724)
    end

    it 'hashes the empty string to zero' do
      expect(''.hash_vl_rb(64)).to eq(0)
    end
  end

  describe '#hash_vl' do
    it 'returns the pure-Ruby hash as a decimal string' do
      expect('В начале'.hash_vl(64)).to eq('В начале'.hash_vl_rb(64).to_s)
    end

    it 'hashes the empty string to "0"' do
      expect(''.hash_vl(64)).to eq('0')
    end
  end
end
