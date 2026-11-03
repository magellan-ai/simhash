# frozen_string_literal: true

include_globs = %w[README* LICENSE Rakefile lib/**/*]

Gem::Specification.new do |s|
  s.name = 'simhash'
  s.version = '0.3.0'
  s.authors = ['Ryan Kerr', 'Alex Gusev']
  s.email = %w[ryan@magellan.ai alex.gusev@bookmate.ru]
  s.homepage = 'https://github.com/magellan-ai/simhash'
  s.license = 'MIT'
  s.description = 'Implementation of Charikar simhashes in Ruby'
  s.summary = 'Convert strings into simhashes for finding near-duplicates, similar strings, etc.'
  s.metadata = { 'rubygems_mfa_required' => 'true' }
  s.required_ruby_version = '>= 3.3'
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob(include_globs, base: __dir__)
  s.require_path = 'lib'

  s.add_dependency 'activesupport', '>= 8.0', '< 8.2'
end
