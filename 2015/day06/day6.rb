Map = Array.new(1000)
#Map.each_index { |y| Map[y] = Array.new(1000, false) }
Map.each_index { |y| Map[y] = Array.new(1000, 0) }

def turn(line)
  #state = line[1] == 'on'
  state = line[1] == 'on' ? 1 : -1
  x_start, y_start = *line[2].split(',').map(&:to_i)
  x_end, y_end = *line.last.split(',').map(&:to_i)
  (y_start..y_end).each do |y|
    (x_start..x_end).each do |x|
      #Map[y][x] = state
      Map[y][x] += state unless state < 0 && Map[y][x] == 0
    end
  end
end

def toggle(line)
  x_start, y_start = *line[1].split(',').map(&:to_i)
  x_end, y_end = *line.last.split(',').map(&:to_i)
  (y_start..y_end).each do |y|
    (x_start..x_end).each do |x|
      #Map[y][x] = !Map[y][x]
      Map[y][x] += 2
    end
  end
end

def star
  File.readlines('input').each do |line|
    line = line.split
    toggle(line) if line[0] == 'toggle'
    turn(line) if line[0] == 'turn'
  end
 # Map.sum { |line| line.count { |light| light }}
  Map.sum { |line| line.sum }
end

p star
