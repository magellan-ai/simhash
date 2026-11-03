# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  enable_coverage :branch

  skip '/spec/'
end

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'simhash'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.around(:example, deprecation_warnings: true) do |example|
    deprecation_warnings_enabled = Warning[:deprecated]
    Warning[:deprecated] = true
    example.run
  ensure
    Warning[:deprecated] = deprecation_warnings_enabled
  end
end
