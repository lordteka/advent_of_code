FABRIC = Array.new(2000) { Array.new(2000, 0) }

class FabricSquare
  def initialize(x_offset, y_offset, width, height)
    @x_offset = x_offset
    @y_offset = y_offset
    @width = width
    @height = height
  end

  def overlap?(other)
    x_range.any? { |x| other.x_range.include? x } && y_range.any? { |y| other.y_range.include? y }
  end

  def print_overlap(other)
    y_range.each do |y|
      x_range.each do |x|
        FABRIC[y][x] = 1 if other.x_range.include?(x) && other.y_range.include?(y)
      end
    end
  end

  def x_range
    @x_range ||= (@x_offset...@width + @x_offset)
  end

  def y_range
    @y_range ||= (@y_offset...@height + @y_offset)
  end
end

fs_list = File.readlines('input').map do |l|
  l.chomp.gsub(/[@x:]/, ',').split(',').drop(1).map { |s| s.to_i }
end.map { |info| FabricSquare.new *info }

fs_list.combination(2).each { |fs, other| fs.print_overlap(other) if fs.overlap? other }

p FABRIC.flatten.sum
