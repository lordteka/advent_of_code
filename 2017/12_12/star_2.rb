def connected_to_key(h, key, connected_to)
  connected_to << key
  h[key].each do |neighbor_key|
    connected_to_key h, neighbor_key, connected_to unless connected_to.include? neighbor_key
  end
  connected_to
end

def groups(h)
  group_array = []
  until h.empty?
    key = h.keys.sample
    group_array << connected_to_key(h, key, [])
    group_array.last.each { |k| h.delete k }
  end
  group_array
end

def f_to_hash(f)
  h = {}
  f.each do |row|
    row = row.split ' <-> '
    h[row[0]] = row[1].split ', '
  end
  h
end

f = File.read('input.txt').split("\n")
h = f_to_hash(f)
p groups(h).length
