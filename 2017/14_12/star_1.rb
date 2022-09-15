require './knot_hash'

input = "vbqugkhl"
count_alloc = 0
(0..127).each do |i|
  kh = KnotHash.new((0..255).to_a, "#{input}-#{i}".chars.map { |c| c.ord } + [17, 31, 73, 47, 23])
  row = kh.round!.sparse_to_dense!.bin_hash
  count_alloc += row.count '1'
end

p count_alloc
