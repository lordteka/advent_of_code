class KnotList
  def initialize(list, length_list)
    @list = list
    @lengths = length_list
    @i = 0
    @len = list.length
    @skip_size = 0
  end

  def compute
    until @lengths.empty?
      insert_sublist(sublist(@lengths[0]))
      @i = (@i + @lengths[0] + @skip_size) % @len
      @lengths.slice! 0
      @skip_size += 1
    end
    @list
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

lengths = File.read('input.txt').split(",").map { |s| s.to_i }
l = KnotList.new((0..255).to_a, lengths).compute
p l
p l[0] * l[1]
