# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'stopwords', 'en')
require File.join(File.dirname(__FILE__), 'stopwords', 'ru')

module Simhash
  module Stopwords
    ALL = (RU + EN).freeze
  end
end
