# frozen_string_literal: true

RSpec.describe Simhash::Stopwords do
  %i[EN RU ALL].each do |list_name|
    it "freezes #{list_name}" do
      expect(described_class.const_get(list_name)).to be_frozen
    end
  end
end
