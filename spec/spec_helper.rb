# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  enable_coverage :branch

  add_filter '/spec/'
end

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'simhash'

reported_deprecations = []

# lib/simhash.rb still calls the deprecated String#mb_chars, once per token, which buries the
# suite output. Report each distinct warning once so it stays visible without drowning results.
ActiveSupport.deprecator.behavior =
  lambda do |message, *|
    next if reported_deprecations.include?(message)

    reported_deprecations << message
    warn(message)
  end

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end
