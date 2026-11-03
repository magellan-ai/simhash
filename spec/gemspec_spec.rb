# frozen_string_literal: true

require 'tmpdir'

RSpec.describe 'simhash.gemspec' do
  subject(:packaged_files) { Dir.chdir(Dir.tmpdir) { Gem::Specification.load(gemspec_path).files } }

  let(:gemspec_path) { File.expand_path('../simhash.gemspec', __dir__) }

  it 'packages the library regardless of the working directory' do
    expect(packaged_files).to include('lib/simhash.rb', 'README.rdoc', 'LICENSE')
  end

  it 'packages only files that exist' do
    root = File.dirname(gemspec_path)
    expect(packaged_files).to all(satisfy { |file| File.exist?(File.join(root, file)) })
  end
end
