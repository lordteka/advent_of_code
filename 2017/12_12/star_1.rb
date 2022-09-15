CONNECTED_TO_0 = []

def connected_to_0(h, key)
  CONNECTED_TO_0 << key
  h[key].each do |neighbor_key|
    connected_to_0 h, neighbor_key unless CONNECTED_TO_0.include? neighbor_key
  end
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
connected_to_0 f_to_hash(f), "0"
p CONNECTED_TO_0.length
