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

    def caught?(i)
      i == @depth && @scanner_index == 0
    end

    def severity
      @depth * @range
    end
  end

  def initialize(file)
    @layers = []
    File.read(file).split("\n").map do |row|
      row = row.split(': ').map { |s| s.to_i }
      @layers << Layer.new(row[0], row[1])
    end
    @max_depth = @layers.max { |l1, l2| l1.depth <=> l2.depth }.depth
  end

  def run_through!
    severity = 0
    (0..@max_depth).each do |i|
      @layers.each do |l|
        severity += l.severity if l.caught? i
        l.next_picosecond!
      end
    end
    severity
  end
end

p Firewall.new('input.txt').run_through!
