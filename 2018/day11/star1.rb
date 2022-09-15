def power_level_grid(serial_number)
  300.times.map do |y|
    300.times.map do |x|
      rack_id = x + 10
      power_level = (rack_id * y + serial_number) * rack_id
      power_level.to_s[-3].to_i - 5
    end
  end
end

def find_area(grid)
  area = { value: -46, x: 0, y: 0}
  297.times do |y|
    297.times do |x|
      area_power_level = grid[y][x] + grid[y][x + 1] + grid[y][x + 2] + \
                          grid[y + 1][x] + grid[y + 1][x + 1] + grid[y + 1][x + 2] + \
                          grid[y + 2][x] + grid[y + 2][x + 1] + grid[y + 2][x + 2]
      area = { value: area_power_level, x: x, y: y } if area_power_level > area[:value]
    end
  end
  area
end

input = 7139
grid = power_level_grid(input)
p find_area(grid)
