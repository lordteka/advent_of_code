f = File.read('input.txt').split("\n").select { |l| l.include?("->") }
left = []
right = []
f.map do |l|
  tmp = l.split("->")
  left << tmp[0]
  right << tmp[1]
end

left = left.join.split(" ").reject { |l| l.include?("(") }
right = right.join(",").split(", ")

p left - right
