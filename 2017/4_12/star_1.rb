valid_count = 0
File.foreach('input.txt') do |line|
  valid_count += 1 unless line.split(" ").uniq.length != line.count(" ") + 1
end
puts valid_count
