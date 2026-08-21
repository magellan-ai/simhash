# frozen_string_literal: true

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

  # String#hash_vl is provided by ext/string_hashing, which is skipped entirely when GMP
  # headers are absent; its specs would raise NoMethodError rather than fail meaningfully.
  config.filter_run_excluding(requires_c_extension: true) unless String.public_method_defined?(:hash_vl)
end
