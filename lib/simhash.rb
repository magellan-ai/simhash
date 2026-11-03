# frozen_string_literal: true

require 'string'
require 'integer'
require 'simhash/stopwords'

module Simhash
  DEFAULT_STRING_HASH_METHOD = :hash_vl_rb
  PUNCTUATION_REGEXP = /(\s|\d|[^\p{L}]|\u00A0| *— *|[«»…\-–—]| )+/

  def self.hash(tokens, options = {}) # rubocop:disable Style/OptionHash
    hashbits = options[:hashbits] || 64
    hashing_method = options[:hashing_method] || DEFAULT_STRING_HASH_METHOD

    v = [0] * hashbits
    masks = v.dup
    masks.each_with_index { |_e, i| masks[i] = (1 << i) }

    each_filtered_token(tokens, options) do |token|
      hashed_token = token.send(hashing_method, hashbits).to_i
      hashbits.times do |i|
        v[i] += hashed_token.nobits?(masks[i]) ? -1 : +1
      end
    end

    fingerprint = 0

    hashbits.times { |i| fingerprint += 1 << i if v[i] >= 0 }

    fingerprint
  end

  def self.each_filtered_token(tokens, options = {}) # rubocop:disable Style/OptionHash, Metrics/PerceivedComplexity
    token_min_size = options[:token_min_size].to_i
    stop_sentenses = options[:stop_sentenses]
    tokens.each do |token|
      # cutting punctuation
      token = token.gsub(PUNCTUATION_REGEXP, ' ') unless options[:preserve_punctuation]

      token = token.strip.downcase

      # cutting stop-words
      token = token.split.select { |w| Stopwords::ALL.index(" #{w} ").nil? }.join(' ') if options[:stop_words]

      # cutting stop-sentenses
      next if stop_sentenses&.include?(" #{token} ")

      next if token.empty? || token.length < token_min_size

      yield token
    end
  end

  def self.filtered_tokens(tokens, options = {}) # rubocop:disable Style/OptionHash
    filtered_tokens = []
    each_filtered_token(tokens, options) { |token| filtered_tokens << token }
    filtered_tokens
  end
end
