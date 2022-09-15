DIRECTIONS = {
  n: [0, 2],
  nw: [-1, 1],
  ne: [1, 1],
  s: [0, -2],
  sw: [-1, -1],
  se: [1, -1]
}

#input = [:ne,:ne,:s,:s] #2
#input = [:ne,:ne,:sw,:sw] #0
#input = [:ne,:ne,:ne] #3
#input = [:se,:sw,:se,:sw,:sw] #3
input = File.read('input.txt').strip.split(',').map{ |d| d.to_sym }

def dist(input)
  dist = [0, 0]
  input.each do |d|
    dist[0] += DIRECTIONS[d][0]
    dist[1] += DIRECTIONS[d][1]
  end
  i = 0
  while dist != [0, 0]
    if dist[0] != 0
      dist[0] > 0 ? dist[0] -= 1 : dist[0] += 1
      dist[1] > 0 ? dist[1] -= 1 : dist[1] += 1
    else
      dist[1] > 0 ? dist[1] -= 2 : dist[1] += 2
    end
    i += 1
  end
  i
end

p dist input
