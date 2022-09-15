COORD_IDX = {
  x: 0,
  y: 1,
  z: 2
}

DATA_IDX = {
  p: 0,
  v: 1,
  a: 2
}

def manhattan_distance(x, y, z)
  x.abs + y.abs + z.abs
end

def run!
  BUFFER.cycle 10000 do |point|
    point[DATA_IDX[:v]][COORD_IDX[:x]] += point[DATA_IDX[:a]][COORD_IDX[:x]]
    point[DATA_IDX[:v]][COORD_IDX[:y]] += point[DATA_IDX[:a]][COORD_IDX[:y]]
    point[DATA_IDX[:v]][COORD_IDX[:z]] += point[DATA_IDX[:a]][COORD_IDX[:z]]
    point[DATA_IDX[:p]][COORD_IDX[:x]] += point[DATA_IDX[:v]][COORD_IDX[:x]]
    point[DATA_IDX[:p]][COORD_IDX[:y]] += point[DATA_IDX[:v]][COORD_IDX[:y]]
    point[DATA_IDX[:p]][COORD_IDX[:z]] += point[DATA_IDX[:v]][COORD_IDX[:z]]
  end
  BUFFER
end

BUFFER = File.read('input.txt').split("\n").map { |l| l.split(', ').map { |data| data.slice(3..-2).split(',').map { |nb| nb.to_i } } }
run!
closest_to_origin = [0, manhattan_distance(*BUFFER[0][DATA_IDX[:p]])]
BUFFER.each_with_index do |point, i|
  md = manhattan_distance *point[DATA_IDX[:p]]
  closest_to_origin = [i, md] if md < closest_to_origin[1]
end
p closest_to_origin
