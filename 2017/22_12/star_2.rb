class Virus
  STATE = {
    '#' => :infected,
    '.' => :clean,
    'W' => :weakened,
    'F' => :flagged
  }

  STATE_CHAR = {
    infected: '#',
    clean: '.',
    weakened: 'W',
    flagged: 'F'
  }

  ORIENTATION = {
    up: {
      left: :left,
      right: :right,
      back: :down
    },
    right: {
      left: :up,
      right: :down,
      back: :left
    },
    down: {
      left: :right,
      right: :left,
      back: :up
    },
    left: {
      left: :down,
      right: :up,
      back: :right
    }
  }

  attr_reader :infection_count

  def initialize(file)
    @grid = File.read(file).split "\n"
    @x = @grid[0].length / 2
    @y = @grid.length / 2
    @heading = :up
    @infection_count = 0
  end

  def burst_n_times!(n)
    n.times do
      burst!
    end
    self
  end

  def burst!
    orienting!
    infecting!
    moving!
    self
  end

  def orienting!
    case STATE[@grid[@y][@x]]
    when :clean
      @heading = ORIENTATION[@heading][:left]
    when :weakened
      #NOOP
    when :infected
      @heading = ORIENTATION[@heading][:right]
    when :flagged
      @heading = ORIENTATION[@heading][:back]
    end
    self
  end

  def infecting!
    case STATE[@grid[@y][@x]]
    when :clean
      @grid[@y][@x] = STATE_CHAR[:weakened]
    when :weakened
      @grid[@y][@x] = STATE_CHAR[:infected]
      @infection_count += 1
    when :infected
      @grid[@y][@x] = STATE_CHAR[:flagged]
    when :flagged
      @grid[@y][@x] = STATE_CHAR[:clean]
    end
    self
  end

  def moving!
    case @heading
    when :up
      @y -= 1
    when :right
      @x += 1
    when :down
      @y += 1
    when :left
      @x -= 1
    end
    expand_grid! if @x >= @grid[0].length || @x < 0 || @y >= @grid.length || @y < 0
    self
  end

  private

  def expand_grid!
    case @heading
    when :up
      @grid.unshift('.' * @grid[0].length)
      @y += 1
    when :right
      @grid.map! { |line| line + '.'}
    when :down
      @grid << '.' * @grid[0].length
    when :left
      @grid.map! { |line| '.' + line }
      @x += 1
    end
    self
  end
end

p Virus.new('input.txt').burst_n_times!(10000000).infection_count
