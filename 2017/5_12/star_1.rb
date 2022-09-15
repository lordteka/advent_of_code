f = File.readlines('input.txt').map { |nb| nb.to_i }
steps = 0
i = 0
len = f.length
while i < len
  f[i] += 1
  i += f[i] - 1
  steps += 1
end
p steps
