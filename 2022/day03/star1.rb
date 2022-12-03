assign = -> ((v, i), h) { h[v] = i }

value =
  ('a'..'z').each.with_index(1).with_object({}, &assign)
    .merge(('A'..'Z').each.with_index(27).with_object({}, &assign))

sum = ARGF.readlines.reduce(0) do |sum, line|
  line = line.chomp.chars
  mid = line.length / 2
  c = (line[0..mid] & line[mid..]).first
  sum += value[c]
end

p sum
