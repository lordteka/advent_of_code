def reactive?(unit1, unit2)
  (unit1.ord - unit2.ord).abs == 32
end

def contains_reactive_unit?(polymer)
  polymer.each_with_index.any? { |unit, index| index + 1 < polymer.length && reactive?(unit, polymer[index + 1]) }
end

def remove_reactive_unit(polymer)
  new_polymer = []
  skip = false
  polymer.each_with_index do |unit, index|
    skip = true and next if !skip && index + 1 < polymer.length && reactive?(unit, polymer[index + 1])
    new_polymer << unit unless skip
    skip = false
  end
  new_polymer
end

polymer = File.read('input').chomp.chars
polymer = remove_reactive_unit polymer while contains_reactive_unit? polymer
p polymer.length
