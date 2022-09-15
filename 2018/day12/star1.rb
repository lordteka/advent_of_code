class Garden
  def initialize(initial_state)
    @right_part = initial_state
    @left_part = Array.new 5, '.'
  end

  def [](index)
    if index >= 0
      @right_part << '.' if index >= @right_part.length
      return @right_part[index]
    end
    @left_part << '.' if -index >= @left_part.length
    @left_part[-(index + 1)]
  end

  def []=(index, value)
    if index >= 0
      @right_part << '.' if index >= @right_part.length
      return @right_part[index] = value
    end
    @left_part << '.' if index >= @left_part.length
    @left_part[-(index + 1)] = value
  end

  def each_with_index
    i = @left_part.length - 1
    i -= 1 while @left_part[i - 2] != '#' && i > 2
    while i >= 0
      yield @left_part[i], -i
      i -= 1
    end
    last_plant = @right_part.rindex('#') + 2
    while i <= last_plant
      yield @right_part[i], i
      i += 1
    end
  end

  def plant_number
    count = 0
    @right_part.each_with_index { |v, i| count += i if v == '#'}
    @left_part.each_with_index { |v, i| count -= (i + 1) if v == '#'}
    count
  end

  def to_s
    @left_part.reverse.sum('') + @right_part.sum('')
  end
end

def spread(garden, gen = 20)
  gen.times do
    #puts garden
    initial_state = []
    garden.each_with_index do |plant, index|
      tmp = garden[index - 2] + garden[index - 1] + plant + garden[index + 1] + garden[index + 2]
      #puts "#{tmp} => #{SPREAD_NOTES[tmp]}" if tmp != "....."
      initial_state << SPREAD_NOTES[garden[index - 2] + garden[index - 1] + plant + garden[index + 1] + garden[index + 2]]
    end
    garden = Garden.new initial_state
  end
  return garden
end

input = File.readlines('input')
initial_state = input.shift(2).first.chomp.chars.drop('initial state: '.length)
SPREAD_NOTES = input.reduce({}) do |h, s|
  tmp = s.chomp.split(' => ')
  h[tmp.first] = tmp.last
  h
end

g = Garden.new initial_state
p spread(g).plant_number
