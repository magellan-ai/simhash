# frozen_string_literal: true

include_globs = %w[README* LICENSE Rakefile init.rb {lib,rails,ext}/**/*]
include_files = include_globs.map { |glob| Dir[glob] }.flatten
exclude_globs = %w[**/*.o **/*.bundle **/Makefile *.bundle]
exclude_files = exclude_globs.map { |glob| Dir[glob] }.flatten

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
  s.files = include_files - exclude_files
  s.require_path = 'lib'
  s.extensions = ['ext/string_hashing/extconf.rb']

  s.add_dependency 'activesupport', '~> 8.0'
  s.add_dependency 'unicode', '>= 0.3.1'
end
