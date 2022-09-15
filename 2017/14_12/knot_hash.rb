class KnotHash
  attr_reader :list

  def initialize(list, length_list)
    @list = list
    @lengths = length_list
    @i = 0
    @len = list.length
    @skip_size = 0
  end

  def round!(nb=64)
    len = @lengths.length
    nb.times do
      lengths_idx = 0
      while lengths_idx < len
        insert_sublist(sublist(@lengths[lengths_idx]))
        @i = (@i + @lengths[lengths_idx] + @skip_size) % @len
        @skip_size += 1
        lengths_idx += 1
      end
    end
    self
  end

  def sparse_to_dense!
    sparse_by_16 = []
    (0..15).each do |nb|
      nb16 = nb * 16
      sparse_by_16[nb] = @list.slice(nb16..(nb16 + 15))
    end
    @list = sparse_by_16.map do |l16|
      l16.inject { |acc, nb| acc = acc ^ nb }
    end
    self
  end

  def bin_hash
    @list.map { |i| i.to_s(2).rjust 8, '0' }.join
  end

  def hex_hash
    @list.map { |i| i.to_s(16).rjust 2, '0' }.join
  end

  private

  def sublist(len)
    sl = []
    tmp_i = @i
    while len > 0
      sl << @list[tmp_i]
      tmp_i = (tmp_i + 1) % @len
      len -= 1
    end
    sl
  end

  def insert_sublist(sl)
    tmp_i = @i
    sl.reverse.each do |e|
      @list[tmp_i] = e
      tmp_i = (tmp_i + 1) % @len
    end
  end
end
