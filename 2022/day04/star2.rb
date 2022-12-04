sum = ARGF.readlines.reduce(0) do |sum, line|
  data = /(\d+)-(\d+),(\d+)-(\d+)/.match(line)
  r1 = data[1].to_i..data[2].to_i
  r2 = data[3].to_i..data[4].to_i

  r1.include?(r2.begin) || r1.include?(r2.end) || r2.include?(r1.begin) || r2.include?(r1.end) ? sum + 1 : sum
end

p sum
