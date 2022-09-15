def star1
  File.read("input").chars.reduce(0) do |acc, c|
    if c == '('
      acc += 1
    else
      acc -= 1
    end
  end
end

def star2
  floor = 0
  File.read("input").chars.each_with_index do |c, idx|
    floor += 1 if c == '('
    floor -= 1 if c == ')'
    return idx + 1 if floor == -1
  end
end

#p star1
p star2
