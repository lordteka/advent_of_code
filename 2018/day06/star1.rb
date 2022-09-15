def manhattan_distance(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

point_list = File.readlines('input').map { |l| l.chomp.split(', ').map &:to_i }
x_size = point_list.max { |p1, p2| p1.first <=> p2.first }.first + 1
y_size = point_list.max { |p1, p2| p1.last <=> p2.last }.last + 1
x_min = point_list.min { |p1, p2| p1.first <=> p2.first }.first
y_min = point_list.min { |p1, p2| p1.last <=> p2.last }.last
area_size_list = Array.new point_list.length, 0
y_size.times do |y|
  x_size.times do |x|
    dist_list = point_list.map.with_index { |p, index| [index, manhattan_distance(x, y, p.first, p.last)] }
    dist_min = dist_list.min { |d1, d2| d1.last <=> d2.last }
    area_size_list[dist_min.first] += 1 unless dist_list.reject { |d| d.last > dist_min.last }.length > 1
  end 
end
p area_size_list
p area_size_list.each_with_index.reject { |_, index| point_list[index].first == x_size || point_list[index].last == y_size || point_list[index].first <= x_min || point_list[index].last <= y_min }.map(&:first).max
