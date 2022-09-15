def star1
  x, y = 0, 0
  map = {}
  File.read("input").chars.each do |direction|
    case direction
    when '^'
      y += 1
    when '>'
      x += 1
    when 'v'
      y -= 1
    when '<'
      x -= 1
    end
    map[y] = {} if map[y].nil?
    map[y][x] = 1
  end
  map.sum { |y, x| x.sum { |k, v| v}}
end

def move(direction, x, y)
  case direction
  when '^'
    [x, y + 1]
  when '>'
    [x + 1, y]
  when 'v'
    [x, y - 1]
  when '<'
    [x - 1, y]
  end
end

Map = {}

def give_present(x, y)
  Map[y] = {} if Map[y].nil?
  Map[y][x] = 1
end

def star2
  x, y, x_robot, y_robot = 0, 0, 0, 0
  File.read("input").chars.each_slice(2) do |direction, direction_robot|
    x, y = *move(direction, x, y)
    give_present(x, y)
    x_robot, y_robot = *move(direction_robot, x_robot, y_robot)
    give_present(x_robot, y_robot)
  end
  Map.sum { |y, x| x.sum { |k, v| v}}
end

#p star1
p star2
