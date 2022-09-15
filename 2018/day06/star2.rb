def manhattan_distance(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

point_list = File.readlines('input').map { |l| l.chomp.split(', ').map &:to_i }
x_size = point_list.max { |p1, p2| p1.first <=> p2.first }.first + 1
y_size = point_list.max { |p1, p2| p1.last <=> p2.last }.last + 1
area_size = 0
y_size.times do |y|
  x_size.times do |x|
    dist_list = point_list.map { |p| manhattan_distance x, y, p.first, p.last }
    area_size += 1 if dist_list.sum < 10000
  end 
end
p area_size
