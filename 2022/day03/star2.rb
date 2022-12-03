assign = -> ((v, i), h) { h[v] = i }

value =
  ('a'..'z').each.with_index(1).with_object({}, &assign)
    .merge(('A'..'Z').each.with_index(27).with_object({}, &assign))

sum = ARGF.readlines.each_slice(3).reduce(0) do |sum, lines|
  badge = lines.map { |line| line.chomp.chars }.reduce(&:&).first
  sum += value[badge]
end

p sum
