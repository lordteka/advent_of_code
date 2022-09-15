class FabricSquare
  attr_reader :id, :overlapping_count

  def initialize(id, x_offset, y_offset, width, height)
    @id = id
    @x_offset = x_offset
    @y_offset = y_offset
    @width = width
    @height = height
    @overlapping_count = 0
  end

  def overlap?(other)
    x_range.any? { |x| other.x_range.include? x } && y_range.any? { |y| other.y_range.include? y }
  end

  def incr_overlapping_count(other=nil)
    @overlapping_count += 1
    other&.incr_overlapping_count
  end

  def x_range
    @x_range ||= (@x_offset...@width + @x_offset)
  end

  def y_range
    @y_range ||= (@y_offset...@height + @y_offset)
  end
end

fs_list = File.readlines('input').map do |l|
  l.chomp.gsub(/[\#@x:]/, ',').split(',').drop(1).map { |i| i.to_i }
end.map { |info| FabricSquare.new *info }

fs_list.combination(2).each { |fs, other| fs.incr_overlapping_count(other) if fs.overlap?(other) }

p fs_list.find { |fs| fs.overlapping_count == 0 }
