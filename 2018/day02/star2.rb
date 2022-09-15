box_ids = File.readlines('input').map { |box_id| box_id.chomp.chars }
diff_index = 0
box_ids.combination(2) do |box_id, other_id|
  differences = 0
  box_id.each_with_index do |c, i|
    differences += 1 and diff_index = i if c != other_id[i]
    break unless differences < 2
  end
  p box_id.tap { |box_id| box_id.delete_at diff_index }.join and exit if differences == 1
end
