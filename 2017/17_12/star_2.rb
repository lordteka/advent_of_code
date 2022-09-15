step = 355
buffer_length = 1
i = 0
ret = 0

(1..50000000).each do |nb|
  i = (i + step) % buffer_length + 1
  ret = nb if i == 1
  buffer_length += 1
end

p ret
