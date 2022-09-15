input = [4, 10, 4, 1, 8, 4, 9, 14, 5, 1, 14, 15, 0, 15, 3, 5]

def reallocate(input)
  i = input.index input.max
  blocks = input[i]
  input[i] = 0
  len = input.length
  while blocks > 0
    i = (i + 1) % len
    input[i] += 1
    blocks -= 1
  end
  input
end

def find_first_cycle(input)
  memory = []
  until memory.include? input
    memory.push Array.new(input)
    input = reallocate input
  end
  memory.length
end

p find_first_cycle input
