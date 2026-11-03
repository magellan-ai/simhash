# frozen_string_literal: true

class String
  def simhash(split_by: ' ', **hash_options)
    Simhash.hash(split(split_by), **hash_options)
  end

  # Decimal-string form of #hash_vl_rb, kept for callers of the removed C extension's method.
  def hash_vl(length)
    hash_vl_rb(length).to_s
  end

  def hash_vl_rb(length)
    return 0 if self == ''

    x = bytes.first << 7
    m = 1_000_003
    mask = (1 << length) - 1
    each_byte { |char| x = ((x * m) ^ char.to_i) & mask }

    x ^= bytesize
    x = -2 if x == -1
    x
  end
end
