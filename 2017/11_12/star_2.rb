DIRECTIONS = {
  n: [0, 2],
  nw: [-1, 1],
  ne: [1, 1],
  s: [0, -2],
  sw: [-1, -1],
  se: [1, -1]
}

input = File.read('input.txt').strip.split(',').map{ |d| d.to_sym }

def step_nb(pos)
  i = 0
  while pos != [0, 0]
    if pos[0] != 0
      pos[0] > 0 ? pos[0] -= 1 : pos[0] += 1
      pos[1] > 0 ? pos[1] -= 1 : pos[1] += 1
    else
      pos[1] > 0 ? pos[1] -= 2 : pos[1] += 2
    end
    i += 1
  end
  i
end

def furthest_pos(input)
  dist = [0, 0]
  f_pos = [0, 0]
  input.each do |d|
    dist[0] += DIRECTIONS[d][0]
    dist[1] += DIRECTIONS[d][1]
    f_pos = Array.new(dist) if step_nb(Array.new(dist)) > step_nb(Array.new(f_pos))
  end
  f_pos
end

p step_nb furthest_pos(input)
