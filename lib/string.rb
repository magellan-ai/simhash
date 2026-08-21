# frozen_string_literal: true

class String
  def simhash(options = {})
    split_by = options.delete(:split_by) || ' '
    Simhash.hash(split(split_by), options)
  end

  def hash_vl_rb(length)
    return 0 if self == ''

    x = bytes.first << 7
    m = 1_000_003
    mask = (1 << length) - 1
    each_byte { |char| x = ((x * m) ^ char.to_i) & mask }

    x ^= bytes.count
    x = -2 if x == -1
    x
  end
end
