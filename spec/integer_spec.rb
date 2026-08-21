# frozen_string_literal: true

RSpec.describe Integer do
  describe '#hamming_distance_to' do
    it 'is zero for an identical integer' do
      expect(2.hamming_distance_to(2)).to eq(0)
    end

    it 'counts a single differing bit' do
      expect(2.hamming_distance_to(3)).to eq(1)
    end

    it 'counts every differing bit' do
      expect(255.hamming_distance_to(197)).to eq(4)
    end
  end
end
