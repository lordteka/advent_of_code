class Star
  attr_reader :x, :y

  def initialize(x, y, vx, vy)
    @x = x
    @y = y
    @vx = vx
    @vy = vy
  end

  def move(i = 1)
    @x += i * @vx
    @y += i * @vy
  end

  def print(sky, h, k) # thank you wiki https://en.wikipedia.org/wiki/Translation_of_axes
    sky[@y - k][@x - h] = '#'
  end
end

stars = []
File.readlines('input').map do |l|
  data = l.match /<(?<position>.+)\>.*?\<(?<velocity>.+)\>/
  stars << Star.new(*data[:position].split(',').map(&:to_i), *data[:velocity].split(',').map(&:to_i))
end

seconds = 0
loop do
  stars.each &:move
  seconds += 1
  min_y, max_y = stars.minmax { |s1, s2| s1.y <=> s2.y }.map &:y
  if (min_y - max_y).abs <= 10
    min_x = stars.min { |s1, s2| s1.x <=> s2.x }.x
    sky = Array.new(12) { Array.new 100, '.' }
    stars.each { |s| s.print(sky, min_x, min_y) }
    sky.each { |l| p l.sum("") }
    break
  end
end
p seconds
