require 'csv'

input = CSV.read("input.txt", col_sep: "\t")
checksum = 0
input.each do |row|
  row.map! { |nb| nb.to_i }
  row.sort.combination(2) { |x, y| checksum += y / x if y % x == 0 }
end
puts checksum
