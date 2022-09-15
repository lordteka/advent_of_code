def side(box)
  [box[0] * box[1], box[1] * box[2], box[2] * box[0]]
end

def star1
  File.readlines("input").reduce(0) do |acc, box|
    side = side(box.split('x').map(&:to_i))
    acc += side.sum { |s| s * 2 } + side.min
  end
end

def star2
  File.readlines("input").reduce(0) do |acc, box|
    dim = box.split('x').map(&:to_i)
    acc += dim.min(2).sum { |d| d * 2 } + dim.reduce(&:*)
  end
end

#p star1
p star2
