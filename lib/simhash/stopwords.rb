# frozen_string_literal: true

require 'yaml'

module Simhash
  module Stopwords
    class << self
      private

      def load_words(locale)
        YAML.safe_load_file(File.join(__dir__, 'stopwords', "#{locale}.yml")).fetch(locale)
      end

      def space_delimited(words)
        " #{words.join(' ')} ".freeze
      end
    end

    ru_words = load_words('ru')
    en_words = load_words('en')

    EN = space_delimited(en_words)
    RU = space_delimited(ru_words)
    ALL = (RU + EN).freeze
  end
end
