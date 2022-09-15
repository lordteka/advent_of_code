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

def collide!
  collision_coord = []
  BUFFER.each_with_index do |point, i|
    collision_coord << point[DATA_IDX[:p]] if BUFFER.index { |p| p[DATA_IDX[:p]] == point[DATA_IDX[:p]] } != i
  end
  collision_coord.uniq!
  BUFFER.delete_if { |p| collision_coord.include? p[DATA_IDX[:p]] }
end

def run!
  100.times do
    BUFFER.each do |point|
      point[DATA_IDX[:v]][COORD_IDX[:x]] += point[DATA_IDX[:a]][COORD_IDX[:x]]
      point[DATA_IDX[:v]][COORD_IDX[:y]] += point[DATA_IDX[:a]][COORD_IDX[:y]]
      point[DATA_IDX[:v]][COORD_IDX[:z]] += point[DATA_IDX[:a]][COORD_IDX[:z]]
      point[DATA_IDX[:p]][COORD_IDX[:x]] += point[DATA_IDX[:v]][COORD_IDX[:x]]
      point[DATA_IDX[:p]][COORD_IDX[:y]] += point[DATA_IDX[:v]][COORD_IDX[:y]]
      point[DATA_IDX[:p]][COORD_IDX[:z]] += point[DATA_IDX[:v]][COORD_IDX[:z]]
    end
    collide!
  end
  BUFFER
end

BUFFER = File.read('input.txt').split("\n").map { |l| l.split(', ').map { |data| data.slice(3..-2).split(',').map { |nb| nb.to_i } } }
run!
p BUFFER.length
