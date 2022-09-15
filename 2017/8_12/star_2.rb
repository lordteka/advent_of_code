f = File.read('input.txt').split("\n")
registers = {}
f.map { |l| l.split(" ")[0] }.uniq.each { |r_name| registers[r_name] = 0 }
instructions = {
  "inc" => ->(name, value) { registers[name] += value },
  "dec" => ->(name, value) { registers[name] -= value },
  ">" => ->(name, value) { registers[name] > value },
  "<" => ->(name, value) { registers[name] < value },
  "<=" => ->(name, value) { registers[name] <= value },
  ">=" => ->(name, value) { registers[name] >= value },
  "==" => ->(name, value) { registers[name] == value },
  "!=" => ->(name, value) { registers[name] != value }
}


tmp = 0
f.each do |line|
  word = line.split(" ")
  instructions[word[1]].call(word[0], word[2].to_i) if instructions[word[5]].call(word[4], word[6].to_i)
  tmp = registers[word[0]] if tmp < registers[word[0]]
end

p tmp
