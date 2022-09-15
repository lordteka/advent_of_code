def anagram?(s1, s2)
  s1.chars.sort == s2.chars.sort
end

valid_count = 0
File.foreach('input.txt') do |line|
  valid_count += 1 unless line.split(" ").combination(2).any? { |s1, s2| anagram? s1, s2 }
end
puts valid_count
