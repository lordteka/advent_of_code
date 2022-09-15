class Rules
  IN = 0
  OUT = 1

  def initialize(file)
    rules = File.read(file).split("\n").map do |line|
      line.split(' => ').map { |s| s.split '/' }
    end
    @two_to_three = rules.select { |r| r[IN].length == 2 }
    @three_to_four = rules.select { |r| r[IN].length == 3 }
  end

  def new_square(old_square)
    rules = old_square.length == 2 ? @two_to_three : @three_to_four
    rules.each do |rule|
      return rule[OUT] if all_square(old_square).include? rule[IN]
    end
  end

  def all_square(square)
    [
      square,
      square.reverse,
      square.map { |l| l.reverse },
      square.map { |l| l.reverse }.reverse,
      square.map { |l| l.chars }.transpose.map { |l| l.join },
      square.map { |l| l.chars }.transpose.map { |l| l.reverse.join },
      square.map { |l| l.chars }.transpose.map { |l| l.join }.reverse,
      square.map { |l| l.chars }.transpose.map { |l| l.reverse.join }.reverse,
    ]
  end
end

class Pattern
  attr_reader :shape

  def initialize(rules)
    @rules = rules
    @shape = ['.#.', '..#', '###']
  end

  def expand_n_time!(n)
    n.times do
      expand!
    end
    self
  end

  def expand!
    @shape.length % 2 == 0 ? split!(2) : split!(3)
    replace!.join!
  end

  def split!(n)
    pre_squares = []
    @shape.each do |l|
      pre_squares << l.scan(/.{#{n}}/)
    end

    squares = []
    (@shape.length / n).times do |y|
      squares[y] = pre_squares[(y * n)...(y * n + n)].transpose
    end
    @shape = squares
    self
  end

  def join!
    @shape = @shape.map { |square| square.transpose.map { |line| line.join } }.flatten
    self
  end

  def replace!
    @shape.map! do |squares|
      squares.map do |square|
        @rules.new_square square
      end
    end
    self
  end
end

p Pattern.new(Rules.new('input.txt')).expand_n_time!(5).shape.inject(0) { |sum, l| sum += l.count('#') }
