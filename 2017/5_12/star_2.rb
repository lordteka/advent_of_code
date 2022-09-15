f = File.readlines('input.txt').map { |nb| nb.to_i }
steps = 0
i = 0
len = f.length
while i < len
  tmp = f[i]
  f[i] >= 3 ? f[i] -= 1 : f[i] += 1
  i += tmp
  steps += 1
end
p steps
