step = 355
buffer = [0]
i = 0

(1..2017).each do |nb|
  i = (i + step) % buffer.length + 1
  buffer.insert i, nb
end

p buffer[i + 1]
