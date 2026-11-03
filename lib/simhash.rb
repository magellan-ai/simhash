# frozen_string_literal: true

require 'string'
require 'integer'
require 'simhash/stopwords'

module Simhash
  DEFAULT_STRING_HASH_METHOD = :hash_vl_rb
  PUNCTUATION_REGEXP = /(\s|\d|[^\p{L}]|\u00A0| *— *|[«»…\-–—]| )+/

  class << self
    def hash(tokens, hashbits: 64, hashing_method: DEFAULT_STRING_HASH_METHOD, **filter_options)
      raise ArgumentError, "unknown hashing_method: #{hashing_method.inspect}" unless ''.respond_to?(hashing_method, true)

      v = [0] * hashbits
      masks = v.dup
      masks.each_with_index { |_e, i| masks[i] = (1 << i) }

      each_filtered_token(tokens, **filter_options) do |token|
        hashed_token = token.send(hashing_method, hashbits).to_i
        hashbits.times do |i|
          v[i] += hashed_token.nobits?(masks[i]) ? -1 : +1
        end
      end

      fingerprint = 0

      hashbits.times { |i| fingerprint += 1 << i if v[i] >= 0 }

      fingerprint
    end

    def each_filtered_token(tokens, token_min_size: 0, stop_sentences: nil, preserve_punctuation: false, stop_words: false, stop_sentenses: nil)
      raise TypeError, "token_min_size must be an Integer, got #{token_min_size.inspect}" unless token_min_size.is_a?(Integer)

      stop_sentences = resolve_stop_sentences(stop_sentences:, stop_sentenses:)
      tokens.each do |token|
        token = normalize_token(token, preserve_punctuation:, stop_words:)
        yield token if keep_token?(token, token_min_size:, stop_sentences:)
      end
    end

    def filtered_tokens(tokens, **filter_options)
      filtered_tokens = []
      each_filtered_token(tokens, **filter_options) { |token| filtered_tokens << token }
      filtered_tokens
    end

    private

    def resolve_stop_sentences(stop_sentences:, stop_sentenses:)
      return stop_sentences if stop_sentenses.nil?
      raise ArgumentError, 'pass stop_sentences: or the deprecated stop_sentenses:, not both' unless stop_sentences.nil?

      warn(
        'Simhash: stop_sentenses: is deprecated; use stop_sentences: instead.',
        uplevel:  external_caller_uplevel,
        category: :deprecated
      )
      stop_sentenses
    end

    def external_caller_uplevel
      caller_locations(1).index { |location| !location.path.start_with?("#{__dir__}/") }
    end

    def normalize_token(token, preserve_punctuation:, stop_words:)
      token = token.gsub(PUNCTUATION_REGEXP, ' ') unless preserve_punctuation
      token = token.strip.downcase
      token = token.split.reject { |w| Stopwords::WORDS.include?(w) }.join(' ') if stop_words
      token
    end

    def keep_token?(token, token_min_size:, stop_sentences:)
      return false if stop_sentences&.include?(" #{token} ")

      !token.empty? && token.length >= token_min_size
    end
  end
end
