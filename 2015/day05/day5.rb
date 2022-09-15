def star1_nice?(string)
  vowel_nb = 0
  consecutive_letter = false
  forbidden_string = false

  string.chars.each_with_index do |c, index|
    vowel_nb += 1 if ['a', 'e', 'i', 'o', 'u'].include? c
    next if index == 0
    consecutive_letter = true if !consecutive_letter && string[index - 1] == c
    forbidden_string = true if ['ab', 'cd', 'pq', 'xy'].include? string[(index - 1)..index]
    return false if forbidden_string
  end

  vowel_nb >= 3 && consecutive_letter
end

def other_pair?(string, pair)
  string.each_with_index do |c, index|
    next if index == 0 || c != pair.last
    return true if string[index - 1] == pair.first
  end
  false
end

def star2_nice?(string)
  same_after_next = false
  two_pair = false
  string = string.chars

  string.each_with_index do |c, index|
    next if index < 2
    same_after_next = true if !same_after_next && string[index - 2] == c
    two_pair = two_pair || (index >= 3 && other_pair?(string[..index - 2], string[(index - 1)..index]))
    return true if same_after_next && two_pair
  end
  false
end

#nice_nb = File.readlines('input').count { |string| star1_nice? string }
nice_nb = File.readlines('input').count { |string| star2_nice? string }

p nice_nb
