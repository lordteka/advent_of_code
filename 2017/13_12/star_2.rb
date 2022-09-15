class Firewall
  class Layer
    attr_reader :depth

    def initialize(depth, range)
      @depth = depth
      @range = range
      @scanner_index = 0
      @incr = 1
    end

    def next_picosecond!
      @scanner_index = @scanner_index + @incr
      @incr = -@incr if @scanner_index == 0 || @scanner_index == @range - 1
    end

    def found_by_scanner?
      loop = (@range - 1) * 2
      (@scanner_index + ((@depth % loop) * @incr)) % loop == 0
    end

    def caught?(i)
      i == @depth && @scanner_index == 0
    end

    def severity
      1
    end
  end

  attr_reader :layers

  def initialize(file)
    @layers = []
    File.read(file).split("\n").map do |row|
      row = row.split(': ').map { |s| s.to_i }
      @layers << Layer.new(row[0], row[1])
    end
    @max_depth = @layers.max { |l1, l2| l1.depth <=> l2.depth }.depth
  end

  def initialize_copy(original)
    @layers = original.layers.map { |l| l.dup }
  end

  def run_through!
    severity = 0
    (0..@max_depth).each do |i|
      @layers.each do |l|
        severity += l.severity if l.caught? i
        l.next_picosecond!
      end
      @layers.unshift if i == @layers[0].depth
    end
    severity
  end

  def found_by_scanner?
    @layers.each do |l|
      return true if l.found_by_scanner?
    end
    false
  end

  def delay!
    @layers.each { |l| l.next_picosecond! }
  end
end

def find_needed_delay(firewall)
  df = firewall.dup
  delay_needed = 0
  while df.found_by_scanner?
    df.delay!
    delay_needed += 1
  end
  delay_needed
end

p find_needed_delay Firewall.new('input.txt')
