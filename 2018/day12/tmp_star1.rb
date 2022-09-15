def spread(garden, gen = 20)
  gen.times do
    #puts garden
    initial_state = []
    garden.each_with_index do |plant, index|
      tmp = (index >= 2) ? garden[index - 2] : '.'
      tmp += (index >= 1) ? garden[index - 1] : '.'
      tmp += plant
      tmp += (index < garden.length - 1) ? garden[index + 1] : '.'
      tmp += (index < garden.length - 2) ? garden[index + 2] : '.'
      initial_state << SPREAD_NOTES[tmp]
    end
    garden = initial_state
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

g = initial_state
count = 0
spread(g).each_with_index { |v, i| count += i if v == '#' } 
p count
