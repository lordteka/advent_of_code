list = File.readlines('input').map { |box_id| box_id.chars }
two_count = 0
three_count = 0
list.each do |box_id|
  found_two = false
  found_three = false
  box_id.each do |c|
    count = box_id.count c
    found_two = true if count == 2
    found_three = true if count == 3
    break if found_two && found_three
  end
  two_count += 1 if found_two
  three_count += 1 if found_three
end

p two_count * three_count
