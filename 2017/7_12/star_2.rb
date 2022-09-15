require 'forwardable'

class Tower
  class Level
    extend Forwardable

    def_delegators :@tower, :line

    attr_reader :name, :weight, :children

    def initialize(tower, line)
      @tower = tower
      @name = name_from line
      @weight = weight_from line
      @children = children_from line
    end

    def total_weight
      @weight + @children.inject(0) { |sum, c| sum += c.total_weight }
    end

    private

    def weight_from(line)
      line.match(/[0-9]+/).to_s.to_i
    end

    def name_from(line)
      line.split(" ").first
    end

    def children_from(line)
      return [] unless line.include? "->"

      children_name = line.split(", ")
      children_name[0] = children_name[0].split(" ").last
      children_name.map { |name| Tower::Level.new @tower, line(name) }
    end
  end

  attr_reader :root

  def initialize(input)
    @file = File.read(input).split("\n")
    @root = Tower::Level.new self, root_line
  end

  def root_line
    line root_name
  end

  def line(name)
    @file[name_index name]
  end

  def corrected_weight
    weights = @root.children.map { |c| c.total_weight }
    wrong_weight = weights.find { |w| weights.count(w) == 1}
    right_weight = weights.find { |w| weights.count(w) > 1}
    diff = right_weight - wrong_weight

    while weights.uniq.length > 1
      wrong_weight_index = weights.index { |w| weights.count(w) == 1 }
      root = root.children[wrong_weight_index]
      weights = root.children.map { |c| c.total_weight }
    end

    root.weight + diff
  end

  private

  def name_index(name)
    @file.index { |l| l.split(" ").first == name }
  end

  def root_name
    left = []
    right = []

    @file.reject { |l| !l.include?("->") }.map do |l|
      tmp = l.split("->")
      left << tmp[0]
      right << tmp[1]
    end
    left = left.join.split(" ").reject { |l| l.include?("(") }
    right = right.join(",").split(", ")

    (left - right)[0]
  end
end

p Tower.new("input.txt").corrected_weight
