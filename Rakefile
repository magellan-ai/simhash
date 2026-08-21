# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: :spec

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

desc 'List the files that will be packaged into the gem'
task :manifest do
  Gem::Specification.load('simhash.gemspec').files.sort.each { |file| puts file }
end

desc 'Start an IRB session with the gem loaded'
task :shell do
  exec 'irb -I lib -r simhash'
end
