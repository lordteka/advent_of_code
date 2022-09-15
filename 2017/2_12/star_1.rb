require 'csv'

input = CSV.read("input.txt", col_sep: "\t")
checksum = 0
input.each do |row|
  row.map! { |nb| nb.to_i }
  checksum += row.max.to_i - row.min.to_i
end
puts checksum
