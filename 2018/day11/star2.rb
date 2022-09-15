def power_level_grid(serial_number)
  300.times.map do |y|
    300.times.map do |x|
      rack_id = x + 10
      power_level = (rack_id * y + serial_number) * rack_id
      power_level.to_s[-3].to_i - 5
    end
  end
end

def find_area(grid, size)
  area = { value: 0, x: 0, y: 0 }
  (300 - size).times do |y|
    (300 - size).times do |x|
      value = grid[y][x]
      value += grid[y + size][x + size] - grid[y][x + size] - grid[y + size][x] if x > 0 && y > 0
      area = { value: value, x: x, y: y } if value > area[:value]
    end
  end
  area[:x], area[:y] = area[:x] + 1, area[:y] + 1 if area[:x] > 0 && area[:y] > 0
  area
end

def find_best_area(grid)
  area = { value: -5, x: 0, y:0, size: 1}
  300.times do |size|
    found_area = find_area(grid, size)
    area = { value: found_area[:value], x: found_area[:x], y: found_area[:y], size: size } if found_area[:value] > area[:value]
  end
  area
end

# Thanks wiki once again : https://en.wikipedia.org/wiki/Summed-area_table
def summed_grid(grid)
  summed_grid = Array.new(300) { Array.new(300) }
  300.times do |y|
    300.times do |x|
     summed_grid[y][x] = grid[y][x]
     summed_grid[y][x] += summed_grid[y - 1][x] if y > 0
     summed_grid[y][x] += summed_grid[y][x - 1] if x > 0
     summed_grid[y][x] -= summed_grid[y - 1][x - 1] if y > 0 && x > 0
    end
  end
  summed_grid
end

input = 7139
grid = power_level_grid(input)
sgrid = summed_grid(grid)
p find_best_area(sgrid)
